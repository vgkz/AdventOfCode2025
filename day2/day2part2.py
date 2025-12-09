def checkValidity(inputId : str) -> bool:
    idLen = len(inputId)
    sequencesToCheck = [inputId[:i] for i in range(1,idLen//2+1)]
    for seq in sequencesToCheck:
        splitId = inputId.split(seq)
        if len([split for split in splitId if split != ""]) == 0:
            return False
    return True

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

def main():
    with open("data.txt") as h:
        data = h.read()
    ids = extractIds(data)
    incorrectIds = [i for i in ids if not checkValidity(i)]
    print(sum([int(i) for i in incorrectIds]))


if __name__ == "__main__":
    main()
