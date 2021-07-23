pipeline{
    agent any
    //Optional tools secrion if you want to use maven from global tool
    tools{
        maven 'mvn362'
    }
    stages{
        stage('checkout'){
            steps{
                //check out code
                git branch: 'main', url: 'https://github.com/thilakpv/spring-petclinic.git'
            }
        }
        stage('build'){
            steps{
            //Optional: Jfrog Artifactory Integration
                rtServer (
                    id: "jfrog-artifactory",
                    url: "http://jfrog-thilak.westus.cloudapp.azure.com:8082/artifactory",
                    credentialsId: "jfrog",
                    bypassProxy: true
                )
                //compile, test, package and deploy the code to self hosted artifactory
                sh 'mvn deploy -Dcheckstyle.skip'
                //Optional: Publish the build info to jfrog artifactory test instance
                rtPublishBuildInfo (
                    serverId: "jfrog-artifactory",
                    buildName: "${BUILD_URL}",
                    buildNumber: "${BUILD_NUMBER}",
                )
            }
        }
        stage('Docker Build'){
            steps{
                 /*rtServer (
                    id: "jfrog-artifactory",
                    url: "http://jfrog-thilak.westus.cloudapp.azure.com:8082/artifactory",
                    credentialsId: "jfrog",
                    bypassProxy: true
                )*/
                //Build the Docker image 
                sh 'docker build -t spring-petclinic:2.4.5 .'
                //Tag the image with registry details
                sh 'docker tag spring-petclinic:2.4.5 thilakvenkata/spring-petclinic:2.4.5'
               // rtDockerPush serverId: "jfrog-artifactory", image: "docker-release-local.jfrog-thilak.westus.cloudapp.azure.com/spring-petclinic:2.4.5", targetRepo: "docker-release-local"
                //Optional Step: Publish the docker image to docker hub
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'paswd', usernameVariable: 'user')]) {
                    sh 'docker login -u ' + user + ' -p ' + paswd + ' docker.io'
                    sh ' docker push thilakvenkata/spring-petclinic:2.4.5'
                }
                
            }
        }
    }
}
