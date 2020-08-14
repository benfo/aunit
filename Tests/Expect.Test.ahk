#Include %A_LineFile%\..\..\AUnit.ahk

class expect_tests
{
  class toBeTrueFalse_tests
  {
    pass()
    {
      expect(true).toBeTrue()
      expect(false).not.toBeTrue()
      expect(false).toBeFalse()
      expect(true).not.toBeFalse()
    }

    fail()
    {
      expectFalse := expect(false).throwFailures()

      expect(expectFalse.toBeTrue.Bind(expectFalse))
        .toThrow("Received: false")

      expect(expectFalse.not.toBeFalse.Bind(expectFalse))
        .toThrow("Received: false")

      expectTrue := expect(true).throwFailures()

      expect(expectTrue.toBeFalse.Bind(expectTrue))
        .toThrow("Received: true")

      expect(expectTrue.not.toBeTrue.Bind(expectTrue))
        .toThrow("Received: true")
    }
  }

  class toBe_tests
  {
    pass()
    {
      expect(1).toBe(1)
      expect(1).not.toBe(2)
    }

    fail()
    {
      expectX := expect(1).throwFailures()
      expect(expectX.toBe.Bind(expectX, 2))
        .toThrow("Expected: 2")

      expect(expectX.not.toBe.Bind(expectX, 1))
        .toThrow("Expected: not 1")

    }
  }
}

AUnit.Test(expect_tests)
