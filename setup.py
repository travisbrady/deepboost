from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy

extensions = [
        Extension("deepboost", [
                "deepboost.pyx",
                "boost.cc", "tree.cc",
            ],
            include_dirs = ['.', numpy.get_include()],
            library_dirs = ['.'],
            language='c++',
            extra_compile_args=['-std=c++11'],
            extra_link_args=["-std=c++11"],
        )
]

setup(
        name='deepboost',
        ext_modules = cythonize(extensions),
)
'''
setup(
    name = "deepboost",
    ext_modules = cythonize('*.pyx',
        language="c++",
        #extra_compile_args=['-std=c++11', '-stdlib=libc++'],
        #extra_link_args=["-std=c++11"],
    ),
    include_dirs=[numpy.get_include()],
)
'''
