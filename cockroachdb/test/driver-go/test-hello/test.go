package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/jackc/pgx/v4"
)

func main() {
	dsn := "postgresql://luojm:ccccc123@crdb.env0.luojm.com:9080/defaultdb?sslmode=verify-ca&sslrootcert=../../cert/ca.crt"
	ctx := context.Background()
	conn, err := pgx.Connect(ctx, dsn)
	defer func() { conn.Close(context.Background()) }()
	if err != nil {
		log.Fatal("failed to connect database", err)
	}

	var text string
	err = conn.QueryRow(context.Background(),
		"SELECT CONCAT('Hello from CockroachDB at ',CAST (NOW() as STRING))").Scan(&text)
	if err != nil {
		fmt.Fprintf(os.Stderr, "QueryRow failed: %v\n", err)
		os.Exit(1)
	}

	fmt.Println(text)
}