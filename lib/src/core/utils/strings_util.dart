class StringsUtil {
  static String cleanJsonResponseString(String corruptedJsonResponse) {
    String jsonString = corruptedJsonResponse.trim();
    if (jsonString.startsWith("```json")) {
      jsonString = jsonString.substring("```json".length).trim();
    }
    if (jsonString.endsWith("```")) {
      jsonString = jsonString.substring(0, jsonString.length - "```".length).trim();
    }
    return jsonString;
  }
}
