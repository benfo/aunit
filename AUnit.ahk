#Include %A_LineFile%\..\Logger.ahk
#Include %A_LineFile%\..\Expect.ahk

class AUnit
{
  static results := []
  static context := ""

  Test(classes*)
  {
    for idx, testClass in classes
    {
      clsInstance := new testClass()
      for key, testFn in testClass
      {
        if (IsObject(testFn) and testFn.HasKey("__Class"))
        {
          AUnit.Test(testFn)
          continue
        }

        if (InStr(key, "__") = 1)
          continue

        if !(IsObject(testFn) && IsFunc(testFn))
          continue

        AUnit.context := { suite: testClass.__Class, test: key }

        try
        {
          %testFn%(clsInstance)
          this.AddPass(key)
        }
        catch ex
        {
          this.AddFail(ex)
          continue
        }
      }

      AUnit.context := ""
    }
  }

  AddFail(ex)
  {
    result := { state: "fail"
      , context: ex.context
      , message: ex.Message
      , line: ex.line
      , file: ex.file
      , toBeFn: toBeFn
      , isNot: this.isNot }

    AUnit.AddResult(result)
  }

  AddPass(fn)
  {
    result := { state: "pass"
            , context: AUnit.context
            , toBeFn: fn
            , isNot: this.isNot }

    AUnit.AddResult(result)
  }

  AddResult(result)
  {
    this.results.Push(result)
    Logger.Log(result)
  }
}
