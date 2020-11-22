# CSVPostFix

## Requirements

1. XCode 12

## How to run

1. Clone the repo
2. Open `CSV RPN.xcodeproj` in XCode
3. In XCode choose a simulator and click run

## Code structure

### Parsers

`CSVParser`

> Parses a file, normalises the cell references and returns back `CSV`. Handles circular references among cells.
> `CSV` contains items `[[CSVCell]]`. Each `CSVCell` contains rawContent:`String` of the cell and normalisedContent:`NormalisedCellContent`.
> `NormalisedCellContent` is an enum of either value or error.
>
> Limitations:
> 1. Currently allows only 26 columns.

`ArithmeticExpressionParser`

> Parses a given arithmetic string expression and returns back `ArithmeticExpression`.
> `ArithmeticExpression` contains items `[ArithmeticExpression.Item]`. `ArithmeticExpression.Item` is an enum of either `case operand(value: Float)` or `case operator(ArithmeticOperator)`
> 
> Limitations:
> 1. Supported operators (`+`, `-`, `*`, `/`)

### Evaluaters

`ArithmeticExpressionEvaluater`
> Takes a `ArithmeticExpression` and returns `ExpressionResult`. `ExpressionResult` is an enum of `value, empty or error`

`PostfixExpressionEvaluater`
> Implements `ArithmeticExpressionEvaluater` and evaluates `ArithmeticExpression` items ordered in PostFix notation order.

### Presenter

`CSVPresenter`
> Uses `CSVParser`, `ArithmeticExpressionParser` and `ArithmeticExpressionEvaluater` to parse and evaluate a CSV cells in postfix notation requests view updates.

### View
`UIViewController`
> Requests `CSVPresenter` to read csv and renders csv values in a UIColllectionView
> Limitations
> 1. Cell sizes are fixed 100 * 50
