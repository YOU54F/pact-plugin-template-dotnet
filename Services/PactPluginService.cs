using Grpc.Core;
using Google.Protobuf.WellKnownTypes;
using Google.Protobuf;

namespace GrpcPactPlugin.Services;

public class PactPluginService : PactPlugin.PactPluginBase
{
    private readonly ILogger<PactPluginService> _logger;
    public PactPluginService(ILogger<PactPluginService> logger)
    {
        _logger = logger;
    }

    public override Task<InitPluginResponse> InitPlugin(
        InitPluginRequest request, ServerCallContext context)
    {
        var response = new InitPluginResponse();
        var contentTypes = new Dictionary<string, string>();
        contentTypes.Add("content-types", "application/matt");
        var catalogueEntries = new[] { new CatalogueEntry
                                        { Key = "dotnet-template",
                                        Type = (CatalogueEntry.Types.EntryType)0,
                                        Values = { contentTypes } } };
        response.Catalogue.Add(catalogueEntries);

        return Task.FromResult(
            response
        );
    }
    public override Task<Empty> UpdateCatalogue(
        Catalogue request, ServerCallContext context)
    { return Task.FromResult(new Empty()); }
    public override Task<ConfigureInteractionResponse> ConfigureInteraction(
        ConfigureInteractionRequest request, ServerCallContext context)


    {
        Console.WriteLine("ConfigureInteraction started.", request);
        var configureInteractionResponse = new ConfigureInteractionResponse();
        var interactionResponse = new InteractionResponse();
        if (request.ContentsConfig.Fields.ContainsKey("request"))
        {

            interactionResponse.PartName = "request";
            var interactionRequestContent = new Body();
            interactionRequestContent.ContentType = "application/matt";
            interactionRequestContent.Content = ByteString.CopyFromUtf8("MATThelloMATT");
            interactionResponse.Contents = interactionRequestContent;
            configureInteractionResponse.Interaction.Add(interactionResponse);
            return Task.FromResult(configureInteractionResponse);
        }

        if (request.ContentsConfig.Fields.ContainsKey("response"))
        {

            interactionResponse.PartName = "response";
            var interactionResponseContent = new Body();
            interactionResponseContent.ContentType = "application/matt";
            interactionResponseContent.Content = ByteString.CopyFromUtf8("MATTworldMATT");
            interactionResponse.Contents = interactionResponseContent;
            configureInteractionResponse.Interaction.Add(interactionResponse);
            return Task.FromResult(configureInteractionResponse);
        }
        return Task.FromResult(configureInteractionResponse);
    }
    public override Task<CompareContentsResponse> CompareContents(
        CompareContentsRequest request, ServerCallContext context)
    {
        var response = new CompareContentsResponse();
        var actual = request.Actual.Content;
        var expected = request.Expected.Content;
        if (actual != expected)
        {
            var contentMismatches = new ContentMismatches();
            var contentMismatch = new ContentMismatch();
            contentMismatch.Actual = actual;
            contentMismatch.Expected = expected;
            contentMismatches.Mismatches.Add(contentMismatch);
            var contentMismatchDict = new Dictionary<string, ContentMismatches>();
            contentMismatchDict.Add("content-types", contentMismatches);
            response.Results.Add(contentMismatchDict);
        }


        return Task.FromResult(response);
    }

    public override Task<GenerateContentResponse> GenerateContent(
        GenerateContentRequest request, ServerCallContext context)
    { return Task.FromResult(new GenerateContentResponse()); }
    public override Task<StartMockServerResponse> StartMockServer(
        StartMockServerRequest request, ServerCallContext context)
    { return Task.FromResult(new StartMockServerResponse()); }
    public override Task<ShutdownMockServerResponse> ShutdownMockServer(
        ShutdownMockServerRequest request, ServerCallContext context)
    { return Task.FromResult(new ShutdownMockServerResponse()); }
    public override Task<MockServerResults> GetMockServerResults(
        MockServerRequest request, ServerCallContext context)
    { return Task.FromResult(new MockServerResults()); }
    public override Task<VerificationPreparationResponse> PrepareInteractionForVerification(
        VerificationPreparationRequest request, ServerCallContext context)
    { return Task.FromResult(new VerificationPreparationResponse()); }
    public override Task<VerifyInteractionResponse> VerifyInteraction(
        VerifyInteractionRequest request, ServerCallContext context)
    { return Task.FromResult(new VerifyInteractionResponse()); }
}
