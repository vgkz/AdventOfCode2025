x = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

def checkValidity(inputId : str) -> bool:
    idLen = len(inputId)
    if (idLen % 2) != 0:
        return True
    else:
        headHalf = inputId[:idLen//2]
        tailHalf = inputId[idLen//2:]
        return not (headHalf == tailHalf)

def strToRange(inputString : str) -> range:
    init, end = inputString.split("-")
    return range(int(init), int(end)+1)

def flatten(inputList : list[list])->list:
    return [nestedval for nestedlist in inputList for nestedval in nestedlist]

def extractIds(inputString : str) -> list[str]:
    strRanges = inputString.split(",")
    nestedValues = [list(strToRange(r)) for r in strRanges]
    values = flatten(nestedValues) 
    return [str(v) for v in values]


ids = extractIds(x)
incorrectIds = [i for i in ids if not checkValidity(i)]
print(sum([int(i) for i in incorrectIds]))
