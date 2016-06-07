import imp
import os
import sys

from mock import *

from gp_unittest import *


class GpCheckCatTestCase(GpTestCase):
    def setUp(self):
        # because gpcheckcat does not have a .py extension, we have to use imp to import it
        # if we had a gpcheckcat.py, this is equivalent to:
        #   import gpcheckcat
        #   self.subject = gpcheckcat
        gpcheckcat_file = os.path.abspath(os.path.dirname(__file__) + "/../../../gpcheckcat")
        self.subject = imp.load_source('gpcheckcat', gpcheckcat_file)

        self.subject.logger = Mock(spec=['log', 'info', 'debug', 'error'])
        self.db_connection = Mock(spec=['close', 'query'])

        self.unique_index_violation_check = Mock(spec=['runCheck'])
        self.unique_index_violation_check.runCheck.return_value = []

        self.leaked_schema_dropper = Mock(spec=['drop_leaked_schemas'])
        self.leaked_schema_dropper.drop_leaked_schemas.return_value = []

        # MagicMock: we are choosing to trust the implementation of GV.cfg
        # If we wanted full coverage we would make this a normal Mock()
        # and fully define its behavior
        self.subject.GV.cfg = {0:dict(hostname='host0', port=123, id=1, address='123', datadir='dir', content=-1, dbid=0),
                               1:dict(hostname='host1', port=123, id=1, address='123', datadir='dir', content=1, dbid=1)}
        self.subject.GV.checkStatus = True
        self.subject.setError = Mock()

        self.apply_patches([
            patch("gpcheckcat.pg.connect", return_value=self.db_connection),
            patch("gpcheckcat.UniqueIndexViolationCheck", return_value=self.unique_index_violation_check),
        ])

    def test_fkQuery__returns_the_correct_query(self):
        expected_query = """
          SELECT input5-1, input5-2, input2_input4,
                 array_agg(gp_segment_id order by gp_segment_id) as segids
          FROM (
                SELECT cat1.gp_segment_id, input6-1, input6-2, cat1.input3 as input2_input4
                FROM
                    gp_dist_random('input1') cat1 LEFT OUTER JOIN
                    gp_dist_random('input2') cat2
                    ON (cat1.gp_segment_id = cat2.gp_segment_id AND
                        cat1.input3 = cat2.input4 )
                WHERE cat2.input4 is NULL
                  AND cat1.input3 != 0
                UNION ALL
                SELECT -1 as gp_segment_id, input6-1, input6-2, cat1.input3 as input2_input4
                FROM
                    input1 cat1 LEFT OUTER JOIN
                    input2 cat2
                    ON (cat1.gp_segment_id = cat2.gp_segment_id AND
                        cat1.input3 = cat2.input4 )
                WHERE cat2.input4 is NULL
                  AND cat1.input3 != 0
                ORDER BY input5-1, input5-2, gp_segment_id
          ) allresults
          GROUP BY input5-1, input5-2, input2_input4
          """
        result_query = self.subject.fkQuery("input1", "input2", "input3", "input4", ["input5-1", "input5-2"], ["input6-1", "input6-2"])

        self.assertEquals(expected_query, result_query)

    @patch('gpcheckcat.checkTableForeignKey')
    def test_checkForeignKey(self, mock1):
        cat_mock = Mock(spec=['getCatalogTables'])
        cat_mock.getCatalogTables.return_value = ["input1", "input2"]
        self.subject.GV.catalog = cat_mock

        self.subject.checkForeignKey()

        self.assertTrue(self.subject.GV.catalog.getCatalogTables.call_count)

        self.assertEquals(len(self.subject.checkTableForeignKey.call_args_list), len(self.subject.GV.catalog.getCatalogTables()))

        for table in self.subject.GV.catalog.getCatalogTables():
            self.assertIn(call(table), self.subject.checkTableForeignKey.call_args_list)

if __name__ == '__main__':
    run_tests()
