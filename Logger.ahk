class Logger
{
  Log(info)
  {
    message := "(" info.state ")`t"
    if (info.context.suite != "")
      message := message info.context.suite " > " Logger.PrettyName(info.context.test) "`n`t"

    if (info.state = "fail")
    {
      message := message (info.isNot ? "not " : "") info.toBeFn
      message := message "`n`t" StrReplace(info.message, "`n", "`n`t") "`n`t(" info.file ":" info.line ")"
    }
    FileAppend % message "`n", *
  }

  PrettyName(value)
  {
    value := RegExReplace(value, "_+", " ") ; replace underscores with spaces
    value := RegExReplace(value, "([A-Z])", " $1") ; insert space before caps letters
    return value
  }
}
