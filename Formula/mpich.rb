class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-3.2.tar.gz"
  sha256 "0778679a6b693d7b7caff37ff9d2856dc2bfc51318bf8373859bfa74253da3dc"
  revision 3

  bottle do
    rebuild 1
    sha256 "c1513b2113b8689535b2ec7fcb5fcb2f7f172ad5492cdfc137083e8b460e4919" => :high_sierra
    sha256 "282396299cfe80cef492b99c79191bf147c984bfb8ed776ef7afea271518eb4c" => :sierra
    sha256 "2ed778ba7dcfc9be44454ea5518276657c55ae29a769e7850bafa6e82d2f9bd9" => :el_capitan
  end

  devel do
    url "https://www.mpich.org/static/downloads/3.3a2/mpich-3.3a2.tar.gz"
    sha256 "5d408e31917c5249bf5e35d1341afc34928e15483473dbb4e066b76c951125cf"
  end

  head do
    url "http://git.mpich.org/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end
  deprecated_option "disable-fortran" => "without-fortran"

  depends_on :fortran => :recommended

  conflicts_with "open-mpi", :because => "both install mpi__ compiler wrappers"

  def install
    # Fix segfault; remove for next mpich releaase > 3.2
    if build.stable? && ENV.compiler == :clang
      inreplace "src/include/mpiimpl.h",
        "} MPID_Request ATTRIBUTE((__aligned__(32)));",
        "} ATTRIBUTE((__aligned__(32))) MPID_Request;"
    end

    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV["MPICH_AUTOTOOLS_DIR"] = HOMEBREW_PREFIX + "bin"
      system "./autogen.sh"
    end

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--mandir=#{man}",
    ]

    args << "--disable-fortran" if build.without? "fortran"

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <mpi.h>
      #include <stdio.h>

      int main()
      {
        int size, rank, nameLen;
        char name[MPI_MAX_PROCESSOR_NAME];
        MPI_Init(NULL, NULL);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Get_processor_name(name, &nameLen);
        printf("[%d/%d] Hello, world! My name is %s.\\n", rank, size, name);
        MPI_Finalize();
        return 0;
      }
    EOS
    system "#{bin}/mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system "#{bin}/mpirun", "-np", "4", "./hello"
    if build.with? "fortran"
      (testpath/"hellof.f90").write <<~EOS
        program hello
        include 'mpif.h'
        integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
        call MPI_INIT(ierror)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
        print*, 'node', rank, ': Hello Fortran world'
        call MPI_FINALIZE(ierror)
        end
      EOS
      system "#{bin}/mpif90", "hellof.f90", "-o", "hellof"
      system "./hellof"
      system "#{bin}/mpirun", "-np", "4", "./hellof"
    end
  end
end
