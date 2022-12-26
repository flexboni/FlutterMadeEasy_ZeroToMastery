import 'package:advicer/0_data/datasources/advice_remote_datasource.dart';
import 'package:advicer/0_data/exceptions/exception.dart';
import 'package:advicer/0_data/models/advice_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'advice_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  group('AdviceRemoteDatasource', () {
    group('should return AdviceModel', () {
      test('when client response was 200 and has valid data', () async {
        final mockClient = MockClient();
        final adviceRemoteDatasourceUnderTest =
            AdviceRemoteDatasourceImpl(client: mockClient);

        const responseBody = '{"advice": "test advice", "advice_id": 1}';

        when(mockClient.get(
          Uri.parse('https://api.flutter-community.com/api/v1/advice'),
          headers: {'content-type': 'application/json'},
        )).thenAnswer(
            (realInvocation) => Future.value(Response(responseBody, 200)));

        final result =
            await adviceRemoteDatasourceUnderTest.getRandomAdviceFromApi();

        expect(result, AdviceModel(advice: 'test advice', id: 1));
      });
    });

    group('should throw', () {
      test('a ServerException when Client response was not 200', () {
        final mockClient = MockClient();
        final adviceRemoteDatasourceUnderTest =
            AdviceRemoteDatasourceImpl(client: mockClient);

        when(mockClient.get(
          Uri.parse('https://api.flutter-community.com/api/v1/advice'),
          headers: {'content-type': 'application/json'},
        )).thenAnswer((realInvocation) => Future.value(Response('', 201)));

        expect(() => adviceRemoteDatasourceUnderTest.getRandomAdviceFromApi(),
            throwsA(isA<ServerException>()));
      });

      test('a Type error when Client response was 200 adn has no valid data',
          () {
        final mockClient = MockClient();
        final adviceRemoteDatasourceUnderTest =
            AdviceRemoteDatasourceImpl(client: mockClient);
        const responseBody = '{"advice": "test advice"}';

        when(mockClient.get(
          Uri.parse('https://api.flutter-community.com/api/v1/advice'),
          headers: {'content-type': 'application/json'},
        )).thenAnswer(
            (realInvocation) => Future.value(Response(responseBody, 200)));

        expect(() => adviceRemoteDatasourceUnderTest.getRandomAdviceFromApi(),
            throwsA(isA<TypeError>()));
      });
    });
  });
}
