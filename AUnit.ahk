#Include %A_LineFile%\..\Logger.ahk
#Include %A_LineFile%\..\Expect.ahk

class AUnit
{
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
        %testFn%(clsInstance)
      }

      AUnit.context := ""
    }
  }
}


; report()
; {
;   totals := { pass: 0, fail: 0, skip: 0 }

;   for idx, result in _Expect.results
;   {
;     if (result.state = "pass")
;     {
;       totals.pass += 1
;       StdOutWriteLine("(PASS) " StrReplace(result.context.test, "_", " ") " (" result.context.suite ")")
;     }
;     else if (result.state = "skip")
;     {
;       ; TODO
;     }
;     else
;     {
;       totals.fail += 1
;       msg := result.message "`n       (" result.ex.File ":" result.ex.Line ")"
;       StdOutWriteLine("(FAIL) " StrReplace(result.context.test, "_", " ") " (" result.context.suite ")`n       " msg)
;     }

;   }

;   FileAppend % "`nFailed: " totals.fail, *
;   FileAppend % "`nPassed: " totals.pass, *
;   if (totals.skip > 0)
;     FileAppend % "`nSkipped: " totals.skip, *
;   FileAppend % "`nTotal: " (totals.pass + totals.fail), *
; }
