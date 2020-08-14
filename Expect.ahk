class Expect
{
  __New(args*)
  {
    this.actual := args[1]
    this.isNot := false
  }

  toThrow(substring := "")
  {
    didThrow := false

    if (IsObject(this.actual))
    {
      try
      {
        this.actual.Call()
      }
      catch ex
      {
        didThrow := true
        thrownEx := ex
      }

      if (!didThrow ^ this.isNot)
      {
        this.recordFail("Received function did " (this.isNot ? "" : "not ") "throw", A_ThisFunc)
        return
      }

      if (substring = "")
        return

      if (didThrow and (InStr(thrownEx.Message, substring) = 0))
      {
        this.recordFail("Expected substring: """ substring """`nReceived: """ thrownEx.Message """", A_ThisFunc)
      }
    }
  }

  toBe(expected)
  {
    if (this.actual = expected) ^ this.isNot
      return

    this.recordFail("Expected: " (this.isNot ? "not " : "") expected, A_ThisFunc)
  }

  toBeTrue()
  {
    if this.actual ^ this.isNot
      return

    this.recordFail("Received: " (this.actual ? "true" : "false"), A_ThisFunc)
  }

  toBeFalse()
  {
    if !this.actual ^ this.isNot
      return

    this.recordFail("Received: " (this.actual ? "true" : "false"), A_ThisFunc)
  }

  recordFail(exception, toBeFn)
  {
    try
    {
      throw Exception(exception, -2)
    }
    catch ex
    {
      if (this.throwFailures = true)
      {
        throw ex
      }

      info := { state: "fail"
        , context: AUnit.context
        , message: ex.Message
        , ex: ex
        , toBeFn: toBeFn
        , isNot: this.isNot }
      Logger.Log(info)
    }
  }

  throwFailures(value := true)
  {
    this.throwFailures := value
    return this
  }

  not
  {
    get
    {
      this.isNot := true
      return this
    }
  }
}

expect(params*)
{
  return new Expect(params*)
}
