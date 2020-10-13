proc CaptureInteraction*(prompt:string,positive,negative:seq[string]):int=
  stdout.write (prompt)
  var answer = readLine(stdin)
  if answer in positive:
    return 1
  elif answer in negative:
    return -1
  else:
    return 0
