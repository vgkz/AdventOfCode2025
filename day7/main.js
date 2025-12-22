const fs = require('node:fs');

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

function nPaths(input, row, col) {
    const row_width = input[0].length;
    const n_rows = input.length;
    // map of beam locations and how many valid paths lead to that location
    const beams = new Map();
    // add first row of beams from S
    for (let i = 0; i < input[0].length;i++) {
        if (input[0][i] == "S") {
            cell_id = "0"+":"+i;
            beams.set(cell_id, 1);
        }
    }
    // iterate through cells adding new beams to map and counting how many paths
    // lead to that beam cell
    for (let row = 1; row < input.length; row++) {
        for (let col = 0; col < row_width; col++) {
            cell_above_id = (row-1)+":"+col;
            if (beams.has(cell_above_id)) {
                above_count = beams.get(cell_above_id);
                if (input[row][col] == ".") {
                    // propogate beam down if a dot
                    cell_id = row+":"+col;
                    if (beams.has(cell_id)) {
                        cur_count = beams.get(cell_id);
                        beams.set(cell_id, cur_count+above_count);
                    } else {
                        beams.set(cell_id, above_count);
                    }
                } else if (input[row][col] == "^") {
                    // split beam if caret
                    if (col>0) {
                        cell_left_id = row + ":" + (col-1);
                        if (beams.has(cell_left_id)) {
                            cur_count = beams.get(cell_left_id);
                            beams.set(cell_left_id, cur_count+above_count);
                        } else {
                            beams.set(cell_left_id, above_count);
                        }
                    }
                    if (col<input[0].length) {
                        cell_right_id = row + ":" + (col+1);
                        if (beams.has(cell_right_id)) {
                            cur_count = beams.get(cell_right_id);
                            beams.set(cell_right_id, cur_count+above_count);
                        } else {
                            beams.set(cell_right_id, above_count);
                        }
                    }
                }
            }
        }
    }
    // count how many valid paths each beam that leads to the last
    // row have. Sum is how many ways there are to move through cells
    var final_count = 0;
    for (let i=0; i<row_width; i++) {
        cell_id = (n_rows-1)+":"+i;
        if (beams.has(cell_id)) {
            final_count = final_count + beams.get(cell_id);
        }
    }
    return (final_count);
}

// read data
fs.readFile("data.txt", 'utf8', (err, data) => {
    if (err) {
        console.error(err);
        return;
    }
    const input_data = data.toString().split("\n");
    // remove last row since its empty
    input_data.splice(input_data.length-1,1);
    // solve part 1
    console.log(countSplits(input_data));
    // solve part 2
    console.log(nPaths(input_data));
});

