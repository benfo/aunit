class Expect
{
  __New(context, args*)
  {
    this.actual := args[1]
    this.isNot := false
    this.context := context
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
        this.throwFail("Received function did " (this.isNot ? "" : "not ") "throw", A_ThisFunc)

      if (substring = "")
        return

      if (didThrow and (InStr(thrownEx.Message, substring) = 0))
        this.throwFail("Expected substring: """ substring """`nReceived: """ thrownEx.Message """", A_ThisFunc)
    }
  }

  toBe(expected)
  {
    if (this.actual = expected) ^ this.isNot
      return

    this.throwFail("Expected: " (this.isNot ? "not " : "") expected "`nReceived: " this.actual, A_ThisFunc)
  }

  toBeTrue()
  {
    if this.actual ^ this.isNot
      return

    this.throwFail("Received: " (this.actual ? "true" : "false"), A_ThisFunc)
  }

  toBeFalse()
  {
    if !this.actual ^ this.isNot
      return

    this.throwFail("Received: " (this.actual ? "true" : "false"), A_ThisFunc)
  }

  throwFail(exception, toBeFn)
  {
    try
    {
      throw Exception(exception, -2)
    }
    catch ex
    {
      throw { file: ex.File
        , line: ex.Line
        , message: ex.Message
        , what: ex.What
        , context: AUnit.context
        , toBeFn: toBeFn
        , isNot: this.isNot
        , state: "fail" }
    }
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

expect(args*)
{
  return new Expect(AUnit.Context, args*)
}
