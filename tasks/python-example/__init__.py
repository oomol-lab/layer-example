from oocana import Context
import pandas as pd
#region generated meta
import typing
class Inputs(typing.TypedDict):
    input: str
class Outputs(typing.TypedDict):
    output: typing.Any
#endregion

def main(params: Inputs, context: Context) -> Outputs:

    p = pd.DataFrame({'a': [1, 2, 3], 'b': [4, 5, 6]})
    context.preview(p)

    return {
      "output": "python"
    }
