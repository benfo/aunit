#Include %A_LineFile%\..\..\AUnit.ahk

class expect_tests
{
  class toBeTrueFalse_tests
  {
    should_pass()
    {
      expect(true).toBeTrue()
      expect(false).not.toBeTrue()
      expect(false).toBeFalse()
      expect(true).not.toBeFalse()
    }

    should_fail_with_exception()
    {
      expectFalse := expect(false)
      expect(expectFalse.toBeTrue.Bind(expectFalse))
        .toThrow("Received: false")
      expect(expectFalse.not.toBeFalse.Bind(expectFalse))
        .toThrow("Received: false")

      expectTrue := expect(true)
      expect(expectTrue.toBeFalse.Bind(expectTrue))
        .toThrow("Received: true")
      expect(expectTrue.not.toBeTrue.Bind(expectTrue))
        .toThrow("Received: true")
    }
  }

  class toBe_tests
  {
    should_pass()
    {
      expect("a").toBe("a")
      expect(1).not.toBe(2)
    }

    should_fail_with_exception()
    {
      expectOne := expect(1)
      expect(expectOne.toBe.Bind(expectOne, 2))
        .toThrow("Expected: 2`nReceived: 1")

      expect(expectOne.not.toBe.Bind(expectOne, 1))
        .toThrow("Expected: not 1`nReceived: 1")

    }
  }

  class toThrow_tests
  {
    should_pass()
    {
      expect(this.__thrower.Bind(this)).toThrow()
      expect(this.__thrower.Bind(this)).toThrow("error")
      expect(this.__noThrow.Bind(this)).not.toThrow()
    }

    should_fail_with_exception()
    {
      expectNoThrow := expect(this.__noThrow.Bind(this))
      expect(expectNoThrow.toThrow.Bind(expectNoThrow))
        .toThrow("Received function did not throw")

      expectThrower := expect(this.__thrower.Bind(this))
      expect(expectThrower.not.toThrow.Bind(expectThrower))
        .toThrow("Received function did throw")

    }

    __thrower()
    {
      throw Exception("error")
    }

    __noThrow()
    {}
  }
}

AUnit.Test(expect_tests)
