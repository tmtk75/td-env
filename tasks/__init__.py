import digdag

class MyWorkflow(object):
  def step1(self):
    print("step1")
    digdag.env.store({"my_var": 123})

  def step2(self, my_var):
      print("step2, my_var:%d" % my_var)

class PrintMyVar(object):
  def main(self, my_var):
      print("my_var: %s" % my_var)
