class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  url "https://www.dynare.org/release/source/dynare-5.2.tar.xz"
  sha256 "01849a45d87cac3c1a8e8bf55030d026054ffb9b1ebf5ec09c9981a08d60f55c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, monterey:     "74b0c0829590cd6f298b2112445986075845a1d795973896a7de1a3b3b943ba8"
    sha256 cellar: :any, big_sur:      "dc535e5c5fe69ccd611b59cf9030bed241491a7f024c60feb4a4eacb9268c1bc"
    sha256 cellar: :any, catalina:     "a130cdc442e3b1889850d4711bc728ed5a93d4903ec0475c5f698840ac8012c6"
    sha256               x86_64_linux: "5f1f77d8c26a48e8b2f9e2a78ea79cfe6e2262d4e47779722ed53a2a9616016e"
  end

  head do
    url "https://git.dynare.org/Dynare/dynare.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  resource "io" do
    url "https://octave.sourceforge.io/download.php?package=io-2.6.4.tar.gz", using: :nounzip
    sha256 "a74a400bbd19227f6c07c585892de879cd7ae52d820da1f69f1a3e3e89452f5a"
  end

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  resource "statistics" do
    url "https://octave.sourceforge.io/download.php?package=statistics-1.4.3.tar.gz", using: :nounzip
    sha256 "9801b8b4feb26c58407c136a9379aba1e6a10713829701bb3959d9473a67fa05"
  end

  def install
    ENV.cxx11

    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      (buildpath/"slicot/lib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    # GCC is the only compiler supported by upstream
    # https://git.dynare.org/Dynare/dynare/-/blob/master/README.md#general-instructions
    gcc = Formula["gcc"]
    gcc_major_ver = gcc.any_installed_version.major
    ENV.send("gcc-#{gcc_major_ver}") # Switch compiler to GCC
    ENV.append "LDFLAGS", "-static-libgcc"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-doc",
                          "--disable-matlab",
                          "--with-boost=#{Formula["boost"].prefix}",
                          "--with-gsl=#{Formula["gsl"].prefix}",
                          "--with-matio=#{Formula["libmatio"].prefix}",
                          "--with-slicot=#{buildpath}/slicot"

    # Octave hardcodes its paths which causes problems on GCC minor version bumps
    flibs = "-L#{gcc.lib}/gcc/#{gcc_major_ver} -lgfortran -lquadmath -lm"
    system "make", "install", "FLIBS=#{flibs}"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    ENV.cxx11

    statistics = resource("statistics")
    io = resource("io")
    testpath.install statistics, io

    cp lib/"dynare/examples/bkk.mod", testpath

    (testpath/"dyn_test.m").write <<~EOS
      pkg prefix #{testpath}/octave
      pkg install io-#{io.version}.tar.gz
      pkg install statistics-#{statistics.version}.tar.gz
      dynare bkk.mod console
    EOS

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "-H", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end

__END__
diff --git a/matlab/+mom/run.m b/matlab/+mom/run.m
index 70de9b1ddba7d1f7d4cb8ea1fd43712429a55111..ec023fed259041253028686c26ccbb8c21271c4e 100644
--- a/matlab/+mom/run.m
+++ b/matlab/+mom/run.m
@@ -63,7 +63,7 @@ function [oo_, options_mom_, M_] = run(bayestopt_, options_, oo_, estim_params_,
 %  o set_all_parameters.m
 %  o test_for_deep_parameters_calibration.m
 % =========================================================================
-% Copyright (C) 2020-2021 Dynare Team
+% Copyright (C) 2020-2022 Dynare Team
 %
 % This file is part of Dynare.
 %
@@ -1017,11 +1017,7 @@ fprintf('\n==== Method of Moments Estimation (%s) Completed ====\n\n',options_mo
 % Step 9: Clean up
 % -------------------------------------------------------------------------
 %reset warning state
-if isoctave
-    warning('on')
-else
-    warning on
-end
+warning_config;

 if isoctave && isfield(options_, 'prior_restrictions') && ...
    isfield(options_.prior_restrictions, 'routine')
diff --git a/matlab/+occbin/kalman_update_algo_1.m b/matlab/+occbin/kalman_update_algo_1.m
index 9600130ae1fa484852c287edb9ae753694e0e474..b7ecb881ae7d69d5a47fe1a8730dbb600a7f451d 100644
--- a/matlab/+occbin/kalman_update_algo_1.m
+++ b/matlab/+occbin/kalman_update_algo_1.m
@@ -42,7 +42,7 @@ function [a, a1, P, P1, v, T, R, C, regimes_, error_flag, M_, lik, etahat] = kal
 % Philipp Pfeiffer, Marco Ratto (2021), Efficient and robust inference of models with occasionally binding
 % constraints, Working Papers 2021-03, Joint Research Centre, European Commission

-% Copyright (C) 2021 Dynare Team
+% Copyright (C) 2021-2022 Dynare Team
 %
 % This file is part of Dynare.
 %
@@ -323,7 +323,7 @@ P(:,:,2) = T(:,:,2)*P(:,:,1)*transpose(T(:,:,2))+QQ;
 regimes_=regimes_(1:3);
 etahat=etahat(:,2);

-warning on
+warning_config;
 end

 function [a, a1, P, P1, v, alphahat, etahat, lik] = occbin_kalman_update0(a,a1,P,P1,data_index,Z,v,Y,H,QQQ,TT,RR,CC,iF,L,mm, rescale_prediction_error_covariance, IF_likelihood)
@@ -424,5 +424,5 @@ while t > 1
     end
 end

-warning on
+warning_config;
 end
diff --git a/matlab/WriteShockDecomp2Excel.m b/matlab/WriteShockDecomp2Excel.m
index 00a51426a76c9c33c13c7d1e265c9f51375edc82..53dce25aa58b810fc3febd0b8a4a19da0928e7f8 100644
--- a/matlab/WriteShockDecomp2Excel.m
+++ b/matlab/WriteShockDecomp2Excel.m
@@ -11,7 +11,7 @@ function WriteShockDecomp2Excel(z,shock_names,endo_names,i_var,initial_date,Dyna
 %   DynareModel     [structure]                     Dynare model structure
 %   DynareOptions   [structure]                     Dynare options structure

-% Copyright (C) 2016-2021 Dynare Team
+% Copyright (C) 2016-2022 Dynare Team
 %
 % This file is part of Dynare.
 %
@@ -124,7 +124,7 @@ for j=1:nvar
     else
         writetable(cell2table(d0), [OutputDirectoryName,filesep,DynareModel.fname,'_shock_decomposition',fig_mode,fig_name1 '.xls'], 'Sheet', endo_names{i_var(j)},'WriteVariableNames',false);
     end
-    warning on
+    warning_config;

     clear d0

diff --git a/matlab/dynare_identification.m b/matlab/dynare_identification.m
index ab39a7242e505235637ed80c8b9832a98ff6e913..d628bc4d91957c3be33bb5f4beff93fca0e43c68 100644
--- a/matlab/dynare_identification.m
+++ b/matlab/dynare_identification.m
@@ -46,7 +46,7 @@ function [pdraws, STO_REDUCEDFORM, STO_MOMENTS, STO_DYNAMIC, STO_si_dDYNAMIC, ST
 %    * skipline
 %    * vnorm
 % =========================================================================
-% Copyright (C) 2010-2021 Dynare Team
+% Copyright (C) 2010-2022 Dynare Team
 %
 % This file is part of Dynare.
 %
@@ -968,11 +968,7 @@ if SampleSize > 1
 end

 %reset warning state
-if isoctave
-    warning('on')
-else
-    warning on
-end
+warning_config;

 fprintf('\n==== Identification analysis completed ====\n\n')

diff --git a/matlab/warning_config.m b/matlab/warning_config.m
index 6a39fced9df3e460067bab3b539900a032adfb0a..c52d8a2f5c8c1842901c7da0a5dafebe5b58844b 100644
--- a/matlab/warning_config.m
+++ b/matlab/warning_config.m
@@ -41,6 +41,7 @@ if isoctave
     warning('off', 'Octave:num-to-str');
     warning('off', 'Octave:resize-on-range-error');
     warning('off', 'Octave:str-to-num');
+    warning('off', 'Octave:array-as-logical');
     warning('off', 'Octave:array-to-scalar');
     warning('off', 'Octave:array-to-vector');
     warning('off', 'Octave:mixed-string-concat');
