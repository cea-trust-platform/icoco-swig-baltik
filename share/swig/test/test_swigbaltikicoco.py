import unittest

class swigbaltikicoco_test(unittest.TestCase):

    def test_simple(self):
        """ Test import of modules and one function in each """
        import medcoupling as mc
        import swigbaltikicoco as swi
        pbT = swi.ProblemTrio()
        pbT.setDataFile("toto.data")

        f = mc.ICoCoMEDDoubleField()
        f.setName("toto")
        self.assertEqual(f.getName(), "toto")

    def test_small_run(self):
        return
  

if __name__ == "__main__":
    unittest.main()
