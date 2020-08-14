class Logger
{
  Log(info)
  {
    message := "(" info.state ")`t"
    if (info.context.suite != "")
      message := message info.context.suite " > " info.context.test "`n`t"

    message := message (info.isNot ? "not " : "") info.toBeFn
    message := message "`n`t" StrReplace(info.ex.Message, "`n", "`n`t") " (" info.ex.File ":" info.ex.Line ")"
    FileAppend % message "`n", *
  }
}
