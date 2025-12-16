const fs = require('node:fs');

const test_input = [".......S.......",
                    "...............",
                    ".......^.......",
                    "...............",
                    "......^.^......",
                    "...............",
                    ".....^.^.^.....",
                    "...............",
                    "....^.^...^....",
                    "...............",
                    "...^.^...^.^...",
                    "...............",
                    "..^...^.....^..",
                    "...............",
                    ".^.^.^.^.^...^.",
                    "..............."];

function countSplits(input) {
    const row_width = input[0].length;
    // Set data structure to keep track of cells that have a beam
    const beams = new Set();
    // count to keep track of number of splits
    var n_splits = 0;
    // initiate beams below S in initial row
    for (let init = 0; init < row_width; init++) {
        if (input[0][init] == "S") {
            beams.add("1:"+init);
        }
    }
    // loop through rows and columns, counting each time a beam is above a splitter
    // update set of beams by adding each new cell that has a beam in it
    for (let row = 1; row < input.length; row++) {
        for (let col = 0; col < row_width; col++) {
            if (beams.has((row-1)+":"+col)) {
                if (input[row][col] == "^") {
                    n_splits = n_splits + 1;
                    // splitter creates two new beams left and right of splitter
                    beams.add((row)+":"+(col-1));
                    beams.add((row)+":"+(col+1));
                } else {
                    // if no splitter, beam continues until it reaches the last row
                    beams.add(row+":"+col);
                }
            }
        }
    }
    return (n_splits);
}

// read data
fs.readFile("data.txt", 'utf8', (err, data) => {
    if (err) {
        console.error(err);
        return;
    }
    const input_data = data.toString().split("\n");
    // solve part 1
    console.log(countSplits(input_data));
});

