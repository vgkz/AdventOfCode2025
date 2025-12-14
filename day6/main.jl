
test_input = ["123 328  51 64 ",
              " 45 64  387 23 ",
              "  6 98  215 314",
              "*   +   *   +  ",] 

function formatData(input)
    # split data into numbers and operators, remove empty space
    map(x -> filter(x -> x != "", split(x," ")), input)
end

function applyOperator(values, operator)
    # apply mathematical operator to list of numbers
    expr = join(values, operator)
    eval(Meta.parse(expr))
end

function main()
    # read data
    data = readlines("data.txt")
    expressions = formatData(data)
    n_expressions = size(expressions[1], 1)
    # solve part 1
    count = 0
    for i = 1:n_expressions
        values = map(x -> x[i], expressions)
        res = applyOperator(values[1:(end-1)], last(values))
        count = count + res
    end
    println(count)
end

# run script
main()
