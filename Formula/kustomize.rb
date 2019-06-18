class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      :tag      => "v2.1.0",
      :revision => "af67c893d87c5fb8200f8a3edac7fdafd61ec0bd"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "890f083da79f381eac8be9731aa6aaab989c043b029a024d9977db40622beca7" => :mojave
    sha256 "60d93cc4d83058d513fb989792af7eae98f91fef6a3a3846c97b334a7333b1e3" => :high_sierra
    sha256 "60256cfa80ffc43bbbb3a0c6c88204a7784dea44b089f55bc436853b08c255c1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip

    dir = buildpath/"src/kubernetes-sigs/kustomize"
    dir.install buildpath.children

    cd dir do
      ldflags = %W[
        -s -X sigs.k8s.io/kustomize/pkg/commands/misc.kustomizeVersion=#{version}
        -X sigs.k8s.io/kustomize/pkg/commands/misc.gitCommit=#{revision}
        -X sigs.k8s.io/kustomize/pkg/commands/misc.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize", "cmd/kustomize/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patches:
      - patch.yaml
    EOS
    (testpath/"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match /type:\s+"?LoadBalancer"?/, output
  end
end
