# GitHub Action to deploy to balena S3 buckets

This github action will copy the artifacts in the provided local path to the corresponding S3 bucket and path.

It uses [s4cmd](https://github.com/bloomreach/s4cmd).

### Configuration

Sensitive options like keys must be [encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables)

Configuration options include:

| Key | Value | Required | Default |
| ------------- | ------------- | ------------- | ------------- |
| `AWS_S3_ACCESS_KEY` | [AWS Access Key](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) | Yes | None |
| `AWS_S3_SECRET_KEY` | [AWS Secret Access Key](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) | Yes | None |
| `AWS_S3_BUCKET` | Bucket name to upload to. | `env` | Yes | None |
| `LOCAL_PATH` | The local directory to upload to S3. | Yes | None |
| `AWS_S3_PATH` | The directory inside of the S3 bucket to upload to. | No | `/` |
| `AWS_REGION` | Bucket's [region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions). | No | `us-east-1` |
| `AWS_S3_ENDPOINT` | For [VPC use cases](https://aws.amazon.com/blogs/aws/new-vpc-endpoint-for-amazon-s3/) or non-AWS services using the S3 API, like [DigitalOcean Spaces](https://www.digitalocean.com/community/tools/adapting-an-existing-aws-s3-application-to-digitalocean-spaces), the bucket's endpoint URL. | No | None |

## License

Distributed under the [MIT license](LICENSE.md).
