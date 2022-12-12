# Development

1. Good [page](https://learn.microsoft.com/en-us/aspnet/core/grpc/protobuf?view=aspnetcore-7.0) for knowledge about construction Protobuf messages in .NET, on Microsoft's site

## Running Locally

1. Install .NET 6+
2. Open the Project.
3. Run `dotnet run`
4. Build with `dotnet build`
   1. Different options for different archs `https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-build`
   2. For full list see https://github.com/dotnet/runtime/blob/main/src/libraries/Microsoft.NETCore.Platforms/src/runtime.json


```
-a|--arch <ARCHITECTURE>

Specifies the target architecture. This is a shorthand syntax for setting the Runtime Identifier (RID), where the provided value is combined with the default RID. For example, on a win-x64 machine, specifying --arch x86 sets the RID to win-x86. If you use this option, don't use the -r|--runtime option. Available since .NET 6 Preview 7.`
```


## Protobuf notes

1. Need to add annotation in the protofile `option csharp_namespace = "GrpcPactPlugin"` for an idiomatic naming convention.