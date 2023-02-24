#!/usr/bin/env groovy

// This file was generated by the CI/CD Wizard version 1.0.421.
// See the user guide for information on how to customize and use this file.

pipeline {
    environment {
        BUILD_CONFIGURATION = 'default'
		PROJECT_NAME = './CI_BuildTest.X'
        SUPPORT_SCRIPT_REPO = 'https://raw.githubusercontent.com/MicrochipTech/cicd-assistant/main'
    }

    // Build orchestrator job can run on any available agent
    // Use --build-agent-label with generate-jenkins to specify
    // a label to restrict agents
    agent any

    stages {
        // The build step will build the source code using the
        // selected compiler to verify that it builds correctly,
        // and store the build artefacts for later use
        stage('Build') {
            agent {
                dockerfile  {
                    // Build agent label to select build agent
                    // to host docker container.
                    // NOTE: This must be a linux based container.
                    label 'docker'
                    filename 'Dockerfile'

                    registryUrl "https://registry.hub.docker.com/"
                }
            }
            steps {
				sh(
					label: 'Running Gitversion'
					script: """
						def props = readProperties file: 'gitversion.properties'

						env.GitVersion_SemVer = props.GitVersion_SemVer
						env.GitVersion_BranchName = props.GitVersion_BranchName
						env.GitVersion_AssemblySemVer = props.GitVersion_AssemblySemVer
						env.GitVersion_MajorMinorPatch = props.GitVersion_MajorMinorPatch
						env.GitVersion_Sha = props.GitVersion_Sha
						echo env.GitVersion_MajorMinorPatch
						"""
				)
				sh( 
					label: 'Stepping to child folder',
					script: """
							ls
							cd ./CI_BuildTest.X
							"""
				)
                sh(
                    label: 'Generate build makefiles',
                    script: "prjMakefilesGenerator.sh -v -f ${env.PROJECT_NAME}@${env.BUILD_CONFIGURATION}"
                )
                sh(
                    label: 'Running Makefile',
                    script: """
							cd ./CI_BuildTest.X
                            rm -rf ./build
                            rm -rf ./dist
							ls
                            make clean
                            make CONF=${env.BUILD_CONFIGURATION}
                            """
                )

                // Store build artefacts for later
                stash name: 'build',
                      includes: 'dist/**/*',
                      allowEmpty: true
            }
        }
        stage('Publish') {
            steps {
				sh(
					script: "ls"
				)
                // Retrieve build artefacts
                unstash 'build'
                dir('./') {	// der Name muss hier raus
                    zip archive: true,
                        glob: '**/*',
                        overwrite: true,
                        zipFile: 'dist.zip'
                }
                recordIssues(tools: [gcc()])
            }
        }
    }
    post {
        // Optional: Add post build actions for various build outcomes.
        // NOTE: The order in which post build actions is executed
        // is fixed (always, changed, success, unstable, failure)
        // regardless of how they appear below.

        // Actions to perform regardless of outcome
        always {
            // Clean workspace after build
            cleanWs()
        }

        // changed { /* Actions to perform when outcome state was changed since last build */ }
        // success { /* Actions to perform for builds that succeed */ }
        // unstable { /* Actions to perform for builds marked as unstable */ }
        // failure { /* Actions to perform for failed builds */ }
    }
}
