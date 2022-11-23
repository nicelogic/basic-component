package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/apache/pulsar-client-go/pulsar"
)

func main(){
	client, err := pulsar.NewClient(pulsar.ClientOptions{
        URL:               "pulsar+ssl://broker.pulsar.env0.luojm.com:9443",
        OperationTimeout:  30 * time.Second,
        ConnectionTimeout: 30 * time.Second,
    })
    if err != nil {
        log.Fatalf("Could not instantiate Pulsar client: %v", err)
    }
    defer client.Close()
    log.Printf("pulsar connect success\n")

    consumer, err := client.Subscribe(pulsar.ConsumerOptions{
        Topic:            "tenant-0/contacts/add_contacts_apply",
        SubscriptionName: "test-sub",
        Type:             pulsar.Shared,
    })
    if err != nil {
        log.Fatal(err)
    }
    defer consumer.Close()
    
    for {
        msg, err := consumer.Receive(context.Background())
        if err != nil {
            log.Fatal(err)
        }
    
        fmt.Printf("Received message msgId: %#v -- content: '%s'\n",
            msg.ID(), string(msg.Payload()))
    
        consumer.Ack(msg)
    }
}