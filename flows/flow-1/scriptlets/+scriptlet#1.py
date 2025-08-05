from oocana import Context
import pandas as pd
#region generated meta
import typing
Inputs = typing.Dict[str, typing.Any]
class Outputs(typing.TypedDict):
    output: typing.Any
#endregion

def main(params: Inputs, context: Context) -> Outputs | None:

    # your code

    df = pd.DataFrame({'A': [1, 2, 3], 'B': ['a', 'b', 'c']})
    context.preview(df) # pyright: ignore[reportArgumentType]
    return {"output": "Hello, world!"}
