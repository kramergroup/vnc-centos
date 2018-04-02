package main

import (
	"fmt"
	"io"
	"net"
	"os"
	"os/signal"
	"strconv"
	"time"
)

type runner struct {
	IP, ID string
}

func main() {
	//endpoint := "unix:///var/run/docker.sock"
	runners := make(chan runner, 10)
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, os.Kill)
	go func() {
		for {
			//var cont *docker.Container
			//client, _ := docker.NewClient(endpoint)
			//cont, _ = client.CreateContainer(docker.CreateContainerOptions{"", &docker.Config{Image: os.Args[1]}, nil})
			//_ = client.StartContainer(cont.ID, nil)
			//cont, _ = client.InspectContainer(cont.ID)
			//fmt.Println("Started ", cont.NetworkSettings.IPAddress)
			select {
			case runners <- runner{/*IP: cont.NetworkSettings.IPAddress, ID: cont.ID*/}:
				fmt.Println("Spawned")
			case sig := <-c:
				fmt.Println("Signal", sig)
				//client.RemoveContainer(docker.RemoveContainerOptions{ID: cont.ID, Force: true})
				fmt.Println("Killing ", "0"/*cont.ID*/)
				close(runners)
				for tokill := range runners {
					fmt.Println("Killing ", tokill.ID)
					//client.RemoveContainer(docker.RemoveContainerOptions{ID: tokill.ID, Force: true})
				}
				os.Exit(0)
			}

		}
	}()
	port, _ := strconv.ParseInt(os.Args[3], 10, 0)
	listener, _ := net.ListenTCP("tcp", &net.TCPAddr{Port: int(port)})
	for {
		conn, _ := listener.AcceptTCP()
		go func() {
			defer conn.Close()
			runner := <-runners
			defer func() {
				//client, _ := docker.NewClient(endpoint)
				fmt.Println("Killing ", runner.ID)
				//client.RemoveContainer(docker.RemoveContainerOptions{ID: runner.ID, Force: true})
			}()
			trys := 0
			var err error
			var runconn net.Conn
			for trys < 3 {
				runconn, err = net.Dial("tcp", fmt.Sprintf("%v:%v", runner.IP, os.Args[2]))
				if err == nil {
					break
				}
				time.Sleep(time.Second)
				trys += 1
			}
			if trys < 3 {
				defer runconn.Close()
				go io.Copy(runconn, conn)
				io.Copy(conn, runconn)
			}
		}()
	}
}
