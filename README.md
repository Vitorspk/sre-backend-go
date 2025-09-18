# SRE Backend Go - Health Check Library

A comprehensive Go library for implementing health checks in microservices and distributed systems. This library provides a flexible framework for monitoring the health status of various service dependencies including databases, message queues, HTTP endpoints, and custom checks.

## Features

- **Multiple Check Types**: Built-in support for various services:
  - HTTP/HTTPS endpoints
  - PostgreSQL databases
  - MySQL databases
  - MongoDB
  - RabbitMQ (including aliveness tests)
  - Redis
  - Memcached
  - gRPC services

- **Flexible Configuration**:
  - Customizable timeouts per check
  - Skip-on-error capability for non-critical services
  - Concurrent health check execution

- **OpenTelemetry Integration**: Built-in distributed tracing support for monitoring health check performance

- **System Metrics**: Automatically includes Go runtime metrics in health responses:
  - Go version
  - Goroutine count
  - Memory allocation statistics
  - Heap objects count

## Installation

```bash
go get github.com/vitorspk/sre-backend-go/v1
```

## Quick Start

```go
package main

import (
    "context"
    "errors"
    "net/http"
    "time"

    health "github.com/vitorspk/sre-backend-go"
    healthHttp "github.com/vitorspk/sre-backend-go/checks/http"
)

func main() {
    // Create a new health instance
    h, _ := health.New()

    // Register a custom health check
    h.Register(health.Config{
        Name:    "custom-check",
        Timeout: time.Second * 5,
        Check: func(ctx context.Context) error {
            // Your custom check logic here
            return nil
        },
    })

    // Register an HTTP health check
    h.Register(health.Config{
        Name:      "api-check",
        Timeout:   time.Second * 3,
        SkipOnErr: true, // Continue even if this check fails
        Check: healthHttp.New(healthHttp.Config{
            URL: "https://api.example.com/health",
        }),
    })

    // Expose health endpoint
    http.Handle("/health", h.Handler())
    http.ListenAndServe(":8080", nil)
}
```

## Available Health Checks

### HTTP Check
```go
healthHttp.New(healthHttp.Config{
    URL:            "https://api.example.com/health",
    RequestTimeout: time.Second * 5,
})
```

### PostgreSQL Check
```go
healthPg.New(healthPg.Config{
    DSN: "postgres://user:pass@localhost:5432/dbname?sslmode=disable",
})
```

### MySQL Check
```go
healthMySql.New(healthMySql.Config{
    DSN: "user:password@tcp(localhost:3306)/dbname?charset=utf8",
})
```

### MongoDB Check
```go
healthMongo.New(healthMongo.Config{
    DSN: "mongodb://user:pass@localhost:27017/",
})
```

### RabbitMQ Check
```go
healthRabbit.New(healthRabbit.Config{
    DSN: "http://guest:guest@localhost:15672/api/aliveness-test/%2f",
})
```

### Redis Check
```go
healthRedis.New(healthRedis.Config{
    DSN: "redis://localhost:6379/0",
})
```

## Health Check Response

The health endpoint returns a JSON response with the following structure:

```json
{
    "status": "true",
    "timestamp": "2024-01-15T10:30:45Z",
    "failures": {},
    "system": {
        "version": "go1.16",
        "goroutines_count": 10,
        "total_alloc_bytes": 1024000,
        "heap_objects_count": 5000,
        "alloc_bytes": 512000
    }
}
```

### Status Values
- `"true"`: All health checks passed
- `"Partially Available"`: Some non-critical checks failed (when using `SkipOnErr: true`)
- `"Unavailable"`: Critical health checks failed
- `"Timeout during health check"`: Check exceeded timeout limit

## Configuration Options

### Health Check Configuration
| Option | Type | Description | Default |
|--------|------|-------------|---------|
| `Name` | string | Unique identifier for the check | Required |
| `Timeout` | time.Duration | Maximum time allowed for check execution | 2 seconds |
| `SkipOnErr` | bool | If true, failures won't affect overall health status | false |
| `Check` | CheckFunc | Function that performs the actual health check | Required |

### OpenTelemetry Integration

To enable distributed tracing:

```go
import "go.opentelemetry.io/otel"

h, _ := health.New(
    health.WithTracerProvider(otel.GetTracerProvider()),
)
```

## Development

### Running Tests

```bash
go test ./...
```

### Running with Docker Compose

A `docker-compose.yml` file is provided for local development with all supported services:

```bash
docker-compose up -d
go run server.go
```

Then access the health endpoint at `http://localhost:3000/status`

## Examples

The repository includes a complete example in `server.go` demonstrating:
- Custom health checks
- Multiple database integrations
- HTTP endpoint monitoring
- RabbitMQ aliveness testing

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Version

Current version: v1.0.0

## Author

Vitor SPK ([@vitorspk](https://github.com/vitorspk))