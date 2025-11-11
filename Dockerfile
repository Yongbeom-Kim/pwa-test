# AWS Lambda adapter for Express server
FROM public.ecr.aws/docker/library/node:20-slim

# Copy AWS Lambda adapter
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter

# Set Lambda adapter port
ENV PORT=3000

# Set working directory for Lambda
WORKDIR "/var/task"

# Install pnpm
RUN npm install -g pnpm

# Copy all source files
COPY . .

# Install dependencies
RUN pnpm install --frozen-lockfile

# Start the server with tsx
CMD ["pnpm", "start"]

