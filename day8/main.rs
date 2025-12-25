const TEST_INPUT: [[i32; 3]; 20] = [
    [162,817,812],
    [57,618,57],
    [906,360,560],
    [592,479,940],
    [352,342,300],
    [466,668,158],
    [542,29,236],
    [431,825,988],
    [739,650,466],
    [52,470,668],
    [216,146,977],
    [819,987,18],
    [117,168,530],
    [805,96,715],
    [346,949,466],
    [970,615,88],
    [941,993,340],
    [862,61,35],
    [984,92,344],
    [425,690,689]
    ];

fn main() {
    let (min_pair, min_dist) = find_min_distance_pairs(&TEST_INPUT);
    let first = TEST_INPUT[min_pair.0];
    let snd = TEST_INPUT[min_pair.1];
    println!("first: {first:?} second: {snd:?}");
}

fn find_min_distance_pairs(input: &[[i32; 3]; 20]) -> ((usize, usize), f32){
    let mut min_dist: f32 = f32::MAX;
    let mut min_pair = (0, 0);
    for (i, arr1) in input.iter().enumerate() {
        for (j, arr2) in &mut input[(i+1)..].iter().enumerate() { 
            let dist = euclidean_distance(&arr1, &arr2);
            if dist < min_dist {
                min_dist = dist;
                // offset inner loop index to match index of full array
                min_pair = (i, j+i+1);
            }
        }
    }
    (min_pair, min_dist)
} 

fn square_difference(x: &i32, y: &i32) -> i32 {
    let s: i32 = x - y;
    s.pow(2)
}

fn euclidean_distance(arr1: &[i32; 3], arr2: &[i32; 3]) -> f32 {
    let d1 = square_difference(&arr1[0], &arr2[0]); 
    let d2 = square_difference(&arr1[1], &arr2[1]);
    let d3 = square_difference(&arr1[2], &arr2[2]);
    let s = d1 + d2 + d3;
    (s as f32).sqrt()
}
