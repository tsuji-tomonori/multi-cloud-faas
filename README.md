# マルチクラウドアプリケーション

同一のソースから, AWS Lambda と Google Cloud Functions へデプロイします.

このアプリは, 入力値の内容をすべて大文字に変換した値を返却します.

## Quick Start!

### 前提条件

- jdk 17 がインストールされていること
- AWS CLI が使用できること
- gcloud CLI が使用できること
- このリポジトリがクローンされていること

### AWS Lambda へデプロイする場合

以下の環境変数を設定します.

```sh
export AWS_PROFILE={YOUR_PROFILE_HERE!!!}
export AWS_ACCOUNT_ID={YOUR_AWS ACCOUNT_ID_HERE!!!}
```

以下のシェルを実行し, デプロイします.

```sh
sh deploy_aws.sh
```

### Google Cloud Functions へデプロイする場合

以下のシェルを実行し, デプロイします.

```sh
sh deploy_gcp.sh
```

## テスト方法

### AWS Lambda に対しテストする場合

以下の環境変数を設定します.

```sh
export AWS_PROFILE={YOUR_PROFILE_HERE!!!}
```

以下のコマンドを実行します.

```sh
aws lambda invoke \
    --function-name function-sample-aws-lambda-01 \
    --cli-binary-format raw-in-base64-out \
    --payload '{ "name": "tsuji" }' \
    aws/log-invoke.json
```

`aws/log-invoke.json` は以下のようになります.

```json
{ "NAME": "TSUJI" }
```

### Google Cloud Functions に対しテストする場合

以下のコマンドを実行します.

```sh
curl https://{YOUR_REGION-PROJECT_ID_HERE!!!}.cloudfunctions.net/function-sample-gcp-http-01 -d "tsuji"
```

以下のような値が返却されます.

```
"TSUJI"
```

## 技術詳細

「Spring Cloud Function」を使用しています.

これは, 各プラットフォームのI/O から, Spring アプリケーションのI/O に変換します. これにより, アプリ実装は各プラットフォームを意識せず, ビジネスロジックに集中することができます.

▼ 今回のアプリ部分

```java
@SpringBootApplication
public class FunctionConfiguration {

	public static void main(String[] args) {
	}

	@Bean
	public Function<String, String> uppercase() {
		return value -> {
			if (value.equals("exception")) {
				throw new RuntimeException("Intentional exception");
			}
			else {
				return value.toUpperCase();
			}
		};
	}
}
```

また, gradle によるビルド時, 環境変数にてプラットフォームを指定し, プラットフォームに合ったライブラリを取得することで, `build.gradle` も共通化しています.

▼ 該当の`build.gradle` 

```groovy
dependencies {
	implementation 'org.springframework.boot:spring-boot-starter'
	implementation "org.springframework.cloud:spring-cloud-function-adapter-${ARCHIVECLASSIFIER}"
	implementation 'org.springframework.cloud:spring-cloud-function-context'
	testImplementation 'org.springframework.boot:spring-boot-starter-test'
}
```

## 参考文献(およびソース)

- https://spring.pleiades.io/projects/spring-cloud-function
- https://spring.pleiades.io/spring-cloud-function/docs/current/reference/html/aws.html
- https://spring.pleiades.io/spring-cloud-function/docs/current/reference/html/gcp.html