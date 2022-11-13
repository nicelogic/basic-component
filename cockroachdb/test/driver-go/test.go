package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/jackc/pgx/v4"
)

func main() {
	dsn := "postgresql://nicelogic:aaB7XEjsDCNA1kA_-kCVeA@free-tier6.gcp-asia-southeast1.cockroachlabs.cloud:26257/defaultdb?sslmode=verify-full&options=--cluster%3Denv-test-cockroach-3570"
	ctx := context.Background()
	conn, err := pgx.Connect(ctx, dsn)
	defer conn.Close(context.Background())
	if err != nil {
		log.Fatal("failed to connect database", err)
	}

	var now time.Time
	err = conn.QueryRow(ctx, "SELECT NOW()").Scan(&now)
	if err != nil {
		log.Fatal("failed to execute query", err)
	}

	fmt.Println(now)
}