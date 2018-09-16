package main

import (
	"github.com/spf13/cobra"
	"os"
	"path/filepath"
	"text/template"
	"path"
	"log"
)

const (
	defaultLocalPort        = 20100
	defaultLocalMetricsPort = 20200
	defaultPublicPortStart  = 30100

	libriVersionFlag    = "libriVersion"
	localPortFlag       = "localPort"
	metricsPortFlag     = "metricsPort"
	publicPortStartFlag = "publicPortStart"
	cpuLimitFlag        = "cpuLimit"
	ramLimitFlag        = "ramLimit"
	diskSizeFlag        = "diskSize"
	localClusterFlag    = "localCluster"
	gcpClusterFlag      = "gcpCluster"
	nLibrariansFlag     = "nLibrarians"

	serviceConfigTemplateFilename = "service.yml.template"
	serviceConfigFilename         = "service.yml"
)

// KubeConfig contains the configuration to apply to the template.
type KubeConfig struct {
	LibriVersion     string
	LocalPort        int
	LocalMetricsPort int
	Librarians       []LibrarianConfig
	CPULimit         string
	RAMLimit         string
	DiskSize         int
	LocalCluster     bool
	GCPCluster       bool
}

// LibrarianConfig contains the public-facing configuration for an individual librarian.
type LibrarianConfig struct {
	PublicPort int
}

var (
	config          KubeConfig
	publicPortStart int
	nLibrarians     int
)

var cmd = &cobra.Command{
	Short: "generate libri service config",
	Run: func(cmd *cobra.Command, args []string) {
		writeConfig()
	},
}

func init() {
	cmd.Flags().StringVar(&config.LibriVersion, libriVersionFlag, defaultLibriVersion,
		"librarian libri version")
	cmd.Flags().IntVar(&config.LocalPort, localPortFlag, defaultLocalPort,
		"librarian server port")
	cmd.Flags().IntVar(&publicPortStart, publicPortStartFlag, defaultPublicPortStart,
		"public port for first librarian")
	cmd.Flags().IntVar(&config.LocalMetricsPort, metricsPortFlag, defaultLocalMetricsPort,
		"librarian metrics port")
	cmd.Flags().StringVar(&config.CPULimit, cpuLimitFlag, defaultCPULimit,
		"librarian pod CPU limit")
	cmd.Flags().StringVar(&config.RAMLimit, ramLimitFlag, defaultRAMLimit,
		"librarian pod RAM limit")
	cmd.Flags().IntVar(&config.DiskSize, diskSizeFlag, defaultDiskSize,
		"librarian data disk size (GB)")
	cmd.Flags().BoolVar(&config.LocalCluster, localClusterFlag, false,
		"whether k8s cluster is running on minikube")
	cmd.Flags().BoolVar(&config.GCPCluster, gcpClusterFlag, true,
		"whether k8s cluster is running on GCP")
	cmd.Flags().IntVar(&nLibrarians, nLibrariansFlag, defaultNLibrarians,
		"number of librarians")
}

func main() {
	if err := cmd.Execute(); err != nil {
		log.Fatal(err)
	}
}

func writeConfig() {
	config.Librarians = make([]LibrarianConfig, nLibrarians)
	for i := range config.Librarians {
		config.Librarians[i].PublicPort = publicPortStart + i
	}
	wd, err := os.Getwd()
	maybeExit(err)
	absTemplateFilepath := filepath.Join(wd, serviceConfigTemplateFilename)
	tmpl, err := template.New(serviceConfigTemplateFilename).ParseFiles(absTemplateFilepath)
	maybeExit(err)
	absConfigFilepath := path.Join(wd, serviceConfigFilename)
	out, err := os.Create(absConfigFilepath)
	maybeExit(err)
	err = tmpl.Execute(out, config)
	maybeExit(err)
}

func maybeExit(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
