package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"io"
	"io/ioutil"
	"log"
	"mime/multipart"
	"net/http"
	"os"
	"strings"
)

// Array of Statement
type DataStatements struct {
	DataStatements []DataStatement
}

// Statement struct which contains a query
type DataStatement struct {
	Query        string
	DocumentPath string
	DocumentName string
}

// Array of Statement
type DesStatements struct {
	DesStatements []DesStatement
}

// Statement struct which contains a query
type DesStatement struct {
	Query string
}

func createMultipartFormData(fileFieldName, filePath string, fileName string, extraFormFields map[string]string) (b bytes.Buffer, w *multipart.Writer, err error) {
	w = multipart.NewWriter(&b)
	var fw io.Writer
	file, err := os.Open(filePath)

	if fw, err = w.CreateFormFile(fileFieldName, fileName); err != nil {
		return
	}
	if _, err = io.Copy(fw, file); err != nil {
		return
	}

	for k, v := range extraFormFields {
		w.WriteField(k, v)
	}

	w.Close()

	return
}

func contains(s []string, e string) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}

func printUsage() {
	log.Println("****************************************** U S A G E ****************************************************************")
	log.Println("go run focusCorpConfig.go -tenant=<tenant> -env=<dev,run> -action=<design,data> -userpassword=<username:password>")
	log.Println("*********************************************************************************************************************")
}

func validateArgument(argument string, isclosed bool, values []string) (result bool) {
	response := true
	if !isclosed {
		if argument == "" {
			response = false
		}
	} else {
		if argument == "" || !contains(values, argument) {
			response = false
		}
	}

	return response
}

func getUsernamePassword(argument string) (username string, password string) {

	res1 := strings.Split(argument, ":")
	return res1[0], res1[1]
}

func main() {

	TENANT := flag.String("tenant", "", "The Platform Engine Tenant")
	ENV := flag.String("env", "", "The Platform Engine Environment")
	ACTION := flag.String("action", "", "The Action for the script to perform")
	USERPASSWORD := flag.String("userpassword", "", "The Action for the script to perform")

	flag.Parse()

	tenant := strings.ToLower(*TENANT)
	env := strings.ToLower(*ENV)
	action := strings.ToLower(*ACTION)
	userpassword := *USERPASSWORD

	validate := 1
	envList := []string{"dev", "run"}
	actionList := []string{"design", "data"}

	if !validateArgument(tenant, false, nil) {
		log.Println("Tenant was not specified")
		validate = 0
	} else {
		if !validateArgument(env, true, envList) {
			log.Println("Environment was not specified or invalid value")
			validate = 0
		} else {
			if !validateArgument(action, true, actionList) {
				log.Println("Action was not specified or invalid value")
				validate = 0
			} else {
				if !validateArgument(userpassword, false, nil) {
					log.Println("UserPassword was not specified")
					validate = 0
				}
			}
		}
	}

	if validate == 0 {
		printUsage()
		os.Exit(0)
	}

	username, password := getUsernamePassword(userpassword)
	graphqlURL := "https://fncm-" + env + "-" + tenant + "/content-services-graphql/graphql"

	log.Println(graphqlURL)

	if action == "design" {
		design(graphqlURL, username, password, env)
	}

	if action == "data" {
		data(graphqlURL, username, password)
	}

}

func data(GraphQL_END_POINT string, username string, password string) {

	//HTTP Client for request
	client := &http.Client{}

	//Read the JSON File for the query statements
	jsonFile, err := os.Open("documents.json")
	if err != nil {
		log.Fatalln(err)
	}

	log.Println("Successfully Opened data.json")
	defer jsonFile.Close()

	//Read the bytes out of the json file
	byteValue, _ := ioutil.ReadAll(jsonFile)

	//Declare de statements variable
	var dataStatements DataStatements

	//write the json bytes into the variable statements
	json.Unmarshal(byteValue, &dataStatements)

	//Process each query in the json file
	for i := 0; i < len(dataStatements.DataStatements); i++ {

		log.Print("*****************************************************************")

		log.Print(i)

		//Prepare the string using escape characters
		queryString := dataStatements.DataStatements[i].Query
		documentPath := dataStatements.DataStatements[i].DocumentPath
		documentName := dataStatements.DataStatements[i].DocumentName

		res1 := strings.ReplaceAll(queryString, "'", "\\\"")

		str1 := "{\"query\":"
		str2 := "\"}\""

		finalStatement := str1 + "\"" + res1 + str2

		extraFields := map[string]string{
			"graphql": finalStatement,
		}

		b, w, err := createMultipartFormData("contvar", documentPath, documentName, extraFields)

		//Confugure the HTTP request options
		req, err := http.NewRequest("POST", GraphQL_END_POINT, &b)

		//Set HTTP headers
		req.Header.Add("Content-Type", w.FormDataContentType())
		req.Header.Set("ECM-CS-XSRF-Token", "123")
		req.Header.Set("Cookie", "ECM-CS-XSRF-Token=123")
		req.SetBasicAuth(username, password)

		//Execute the request
		resp, err := client.Do(req)
		if err != nil {
			log.Fatalln(err)
		}

		log.Println("Status:", resp.StatusCode)

		//Analize the response code of the call

		//We Read the response body on the line below.
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			log.Fatalln(err)
		}
		//Convert the body to type string
		sb := string(body)

		log.Println(sb)

		log.Print("*****************************************************************")

	}

	log.Println("Documents Uploaded Succesfully")
	//PROGRAM FINISHED
}

func design(GraphQL_END_POINT string, username string, password string, env string) {

	//HTTP Client for request
	client := &http.Client{}

	//Read the JSON File for the query statements
	jsonFile, err := os.Open("folders.json")

	if err != nil {
		log.Fatalln(err)
	}

	log.Println("Successfully Opened folders.json")
	defer jsonFile.Close()

	//Read the bytes out of the json file
	byteValue, _ := ioutil.ReadAll(jsonFile)

	//Declare de statements variable
	var desStatements DesStatements

	//write the json bytes into the variable statements
	json.Unmarshal(byteValue, &desStatements)

	//Process each query in the json file
	for i := 0; i < len(desStatements.DesStatements); i++ {

		if env == "dev" && (i == 1 || i == 40) {
			continue
		}

		log.Print("*****************************************************************")

		log.Print(i)

		//Prepare the string using escape characters
		queryString := desStatements.DesStatements[i].Query
		res1 := strings.ReplaceAll(queryString, "'", "\\\"")
		str1 := "{\"query\":"
		str2 := "\"}\""

		finalStatement := str1 + "\"" + res1 + str2

		bodyReader := bytes.NewReader([]byte(finalStatement))

		//Confugure the HTTP request options
		req, err := http.NewRequest("POST", GraphQL_END_POINT, bodyReader)

		//Set HTTP headers
		req.Header.Set("ECM-CS-XSRF-Token", "123")
		req.Header.Set("Cookie", "ECM-CS-XSRF-Token=123")
		req.SetBasicAuth(username, password)

		//Execute the request
		resp, err := client.Do(req)
		if err != nil {
			log.Fatalln(err)
		}

		log.Println("Status:", resp.StatusCode)

		//Analize the response code of the call

		//We Read the response body on the line below.
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			log.Fatalln(err)
		}

		//Convert the body to type string
		sb := string(body)

		log.Println(sb)

		log.Print("*****************************************************************")

	}

	log.Println("Folders Created Succesfully")
	//PROGRAM FINISHED
}
