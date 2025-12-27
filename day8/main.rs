use std::collections::HashSet;
use std::collections::HashMap;
use std::fs;
use std::convert::TryInto;

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
    //let test_vect = Vec::from(&TEST_INPUT);
    // read data
    let data = fs::read_to_string("data.txt")
        .expect("failed to read");
    let input = process_data(data);
    // solve part 1
    let set_map = connect_circuits(&input, 1000 as usize);
    let sizes = get_n_largest_circuit_sizes(&set_map, 3);
    let prod = &sizes.iter().fold(1, |acc, x| acc*x);
    println!("{prod}");
}

fn process_data(data: String) -> Vec<[i32;3]>{
    let lines: Vec<String> = data.lines().filter(|l| !l.is_empty()).map(String::from).collect();
    let split_lines: Vec<[i32;3]>= lines.iter()
        .map(|x| x.split(",")
            .map(|c| c.parse::<i32>().unwrap())
            .collect::<Vec<i32>>()
            .try_into()
            .unwrap())
        .collect();
    split_lines
}

fn get_n_largest_circuit_sizes(circuits: &HashMap<usize, HashSet<usize>>, n: usize) -> Vec<usize> {
    let mut sizes: Vec<usize> = circuits.values().map(|x| x.len()).collect();
    sizes.sort();
    sizes.reverse();
    sizes[..n].iter().copied().collect()
}

fn connect_circuits(input: &Vec<[i32;3]>, target_n_connections: usize) -> HashMap<usize, HashSet<usize>> {
    // initialize circuits
    let mut circuits: HashMap<usize, HashSet<usize>> = HashMap::new();
    for i in 0..input.len() {
        let set: HashSet<usize> = HashSet::from([i]);
        circuits.insert(i+1, set);
    }
    // compute distances and sort
    let mut dist_pairs = find_distance_pairs(&input);
    dist_pairs.sort_by(|a,b| a.1.partial_cmp(&b.1).unwrap());
    // connect circuits until n_connections made
    for (min_pair, _dist) in &mut dist_pairs[..target_n_connections] {
        circuits = update_sets(circuits, *min_pair);
    }
    circuits
}

fn update_sets(mut set_map: HashMap<usize, HashSet<usize>>, min_pair: (usize, usize)) -> HashMap<usize, HashSet<usize>>{
    let mut index0_set: usize = 0;
    let mut index1_set: usize = 0;
    // locate indices in sets
    for (key, set) in set_map.iter_mut() {
        if set.contains(&min_pair.0) {
            index0_set = *key;
        }
        if set.contains(&min_pair.1) {
            index1_set = *key;
        }
        if (index0_set != 0) && (index1_set != 0) {
            break
        }
    }
    // update sets
    if index0_set != index1_set {
        if let Some(set0) = set_map.get(&index0_set) {
            if let Some(set1) = set_map.get(&index1_set) {
                let union_set = set0.union(set1).copied().collect();
                set_map.insert(index0_set, union_set);
                set_map.remove(&index1_set);
            }
        }
    }
    set_map
}

fn find_distance_pairs(input: &Vec<[i32; 3]>) -> Vec<((usize, usize), f32)>{
    let mut out: Vec<((usize, usize), f32)> = Vec::new();
    let mut c: usize = 0;

    for (i, arr1) in input.iter().enumerate() {
        for (j, arr2) in &mut input[(i+1)..].iter().enumerate() { 
            let dist = euclidean_distance(&arr1, &arr2);
            out.push(((i,j+i+1),dist));
            c = c+1;
        }
    }
    out
} 

fn square_difference(x: &i32, y: &i32) -> f32 {
    let s: f32 = (x - y) as f32;
    s.powf(2.0)
}

fn euclidean_distance(arr1: &[i32; 3], arr2: &[i32; 3]) -> f32 {
    let d1 = square_difference(&arr1[0], &arr2[0]); 
    let d2 = square_difference(&arr1[1], &arr2[1]);
    let d3 = square_difference(&arr1[2], &arr2[2]);
    let s = d1 + d2 + d3;
    (s as f32).sqrt()
}
