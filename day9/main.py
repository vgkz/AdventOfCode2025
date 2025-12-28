from itertools import combinations 

TEST_INPUT = [(7,1),
              (11,1),
              (11,7),
              (9,7),
              (9,5),
              (2,5),
              (2,3),
              (7,3)]

def main():
    # read data
    input_data = parse_data("data.txt")
    print(input_data[1])
    # solve part 1
    ## compute max area of all coordinate pairs
    max_area = get_max_area(input_data)
    print(max_area)

def parse_data(filepath):
    with open(filepath, "r") as h:
        lines = h.readlines()
    split_lines = [tuple(l.split(",")) for l in lines]
    numeric_split_lines = map(lambda t: (int(t[0]), int(t[1])), split_lines) 
    return list(numeric_split_lines)

def get_max_area(coords):
    coord_pairs = combinations(coords, 2)
    areas = [area(c1, c2) for (c1, c2) in coord_pairs]
    return max(areas)

def area(t1, t2):
    return abs(t1[0]-t2[0]+1) * abs(t1[1]-t2[1]+1)

if __name__ == "__main__":
    main()

