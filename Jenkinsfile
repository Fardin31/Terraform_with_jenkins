pipeline {
    agent any

    stages {
        stage('Terraform Prompt') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'AWS_CRED',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        // Execute terraform init
                        sh 'terraform init'

                        def userInput = input(
                            id: 'terraform-action',
                            message: 'Do you want to apply or destroy Terraform infrastructure?',
                            parameters: [
                                choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select an action')
                            ]
                        )

                        // Execute Terraform based on user input
                        if (userInput == 'apply') {
                            sh 'terraform apply -auto-approve'
                        } else if (userInput == 'destroy') {
                            sh 'terraform destroy -auto-approve'
                        }
                    }
                }
            }
        }
    }

   /* post {
        always {
            // Remove workspace directory after Terraform commands
            deleteDir()
        }
    }*/
}
