import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "buzzchat-chat-app",
        "private_key_id": "56bd5c5cfec10bd0410e1121f362f7f194955239",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCUOYFiJb15qVFR\nC5jY8/bxVvYuqM6pGuyI6TScm6q6FVTrYl1lftUa82xm1+OBhT4J5HslOKrCU+jO\n8QmjRscXE85+aOXtKqAQux5mvsZlPVNydNzdyi6wzAnfu4h1wrayiIhTZ8/OxiFY\nzU5UHQitn7fZzaEQOcco3MNX4R3TwuudO0KHPH26PzHlUKFL9sE4AciY/mS1zaJk\n3h9RHuvARf9d4pKuMQLo72LX/WQQ0rRShrbny10BMDEAMQxccDqWexh6WeBCU2/W\nLJ1hJJ7Q4KMp6yZF/vJqvlEg2GVLAzFcYAI5wdDWRZdUJefBLNzZK/q7B8m5e4W1\nbGRqzd+JAgMBAAECggEAGeipWH4PThZOC/QSfg264vmX45UHNqDpqo7U7vD42TkE\nVHanq6eNWX4mOx3OeyPOscz5x4pNstUW8yFH1X34K+z+4bK1Sgzy2KnUiRIcvLKJ\nBQ8vUidWnPm1WiG+GxNzeuaJqcaSGOsiBhMw91vx2eN6r/wVBLCMwvQ/wvsrCwoZ\npodTM2BGUdchSIwWtVAWEPTCjGXxUrzUTOgBMkFvUTw4QEh9wsW0aqdr/1swRFWl\nTbqmX2TA78NioL+pcPyCO2OJntfs8B1VRD7thOahvD3LG1nNoNoV6PGEQlqssS0m\nnoIzdCk+QvtGVVios86547TFS478b63DobrMlJA23wKBgQDHGRA1UxmAzjXdGgiW\njEoK3UfBPNSUKSPUoWYdy0p8FotohotSq4maVCXrP+nUSSMA++4jc5YZXc7K9yAg\nIKxtiDf26YTqslInNEwrrTGKZGXHL6mtn/CfuP6kinEFeIUF3z9N9G8wiFQc93CE\nNn5BkzDuh4XdVQzD8N3dYz0cOwKBgQC+llCULVf4GoUh+8FzC8WfAvvUlVP6qLSv\nolIi1juObnZ/Rp0vYMge7XFH+hC7YRG8OWC9JzJASSVXr3gYomKNOQpKWjEL3UD0\nNqZbhA5I3VgzsucWgb927g3/QNN9XmbjdbCqp0Fuf5ZLNN/kdABIG/bNOBI+H8E5\nDAC0TBNrCwKBgEsxNQTemIAj4QXa4ilxXDlULthVD/fQvb59IiLYdw38ObRFM/MJ\n49MMOrHpFnddE8I4Y0yyR5rW6dWPlWtsy5ImYvR2ZwN4SzyRLL9GDrK0jhe28X8o\nK2k3JbygqGSnip2YHcFkMmYC5rl13eGg7vf3DgDX3/+iMksB+di1tQunAoGAMmxc\nd0ej3Y1OqdYMsV5s84v7ipvTcx7NZyZf6r2ZVi6dhUDud0l4yM3zSaK8aIbfBVh8\n4q6LGf0ANznCYWoc/tYXheJk1Ym9FJ+c1duTV+3P1yW/A/Jh8Jo888p36dRfDlDl\n49CKfCyfW9hqX+vc4zcazeLG2M7X9TrauNjjzk8CgYB+iwOT+Lg2UYokK4ZeJEMa\nJZNp5mTMZM05xQI0dh7A4+588q3ApTEVUDi+WWnga1VXMPpDbkpsYDPUJoTReCVL\nvzfrldla78vnT3fHZ3OWbWkzkQYCxvgwQH/w5uf+lMupVcEhyCzaIuZLuRG1Q5yl\n1S363KlUaozTXY9WOk7ReA==\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@buzzchat-chat-app.iam.gserviceaccount.com",
        "client_id": "111482211458423432839",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40buzzchat-chat-app.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
