function formatData(input)
    # split data into numbers and operators, remove empty space
    map(x -> filter(x -> x != "", split(x," ")), input)
end

function formatDataPart2(input)
    # extract values from columns and output with relevant operator
    operators = input[end]
    op_ranges = findall.(["+","*"], operators)
    op_indices = sort(map(range->first(range),vcat(op_ranges[1],op_ranges[2])))
    output = []
    for i = 1:length(op_indices)
        op1_i = op_indices[i]
        if (i == length(op_indices))
            # if last expression, get vals until last column
            op2_i = length(input[end])+1
        else
            op2_i = op_indices[i+1]
        end
        vals = []
        # extract columns until next column
        for j = op1_i:(op2_i-1)
            digits = map(x-> x[j], input[1:end-1])
            push!(vals, String(digits))
        end
        # remove any columns that did not have a value in it
        vals = filter(x -> strip(x) != "", vals)
        push!(output, [vals, operators[op1_i]])
    end
    output
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
    vals_and_operators = formatDataPart2(data)
    n_expressions = size(expressions[1], 1)
    # solve part 1
    count = 0
    for i = 1:n_expressions
        values = map(x -> x[i], expressions)
        res = applyOperator(values[1:(end-1)], last(values))
        count = count + res
    end
    println(count)
    # solve part 2
    count2 = 0
    for expr in vals_and_operators
        vals = expr[1]
        operator = expr[2]
        res = applyOperator(vals, operator)
        count2 = count2 + res
    end
    println(count2)
end

# run script
main()
