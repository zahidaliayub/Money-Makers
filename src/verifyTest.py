import requests

url = "http://localhost:8080"

payload = "{\n\t\"webhookUrl\": \"http://localhost:8080\",\n    \"expectedResult\": {\n    \t\"status\": \"success\",\n\t\t\"verificationStatus\": \"verified\",\n\t\t\"verificationUuid\": \"uniqueVerificationId\",\n\t\t\"userId\": \"yourUserId\"\n    }\n}"
headers = {'Content-Type': 'application/json'}

response = requests.request("POST", url, data=payload, headers=headers)

print(response.text)
