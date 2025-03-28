import { type Build } from 'cmake-ts-gen';

const build: Build = {
    common: {
        project: 'libbson',
        archs: ['x64'],
        variables: [
            ['EXPAT_DEBUG_POSTFIX', '_d', true],
            ['EXPAT_RELEASE_POSTFIX', '', true],
        ],
        copy: {},
        defines: [],
        options: [
            ['EXPAT_SHARED_LIBS', false],
            ['EXPAT_BUILD_TESTS', false],
            ['EXPAT_BUILD_EXAMPLES', false]
        ],
        subdirectories: ['libexpat/expat'],
        libraries: {
            'expat': {
                name: 'libexpat'
            }
        },
        buildDir: 'build',
        buildOutDir: '../libs',
        buildFlags: []
    },
    platforms: {
        win32: {
            windows: {},
            android: {
                archs: ['x86', 'x86_64', 'armeabi-v7a', 'arm64-v8a'],
            }
        },
        linux: {
            linux: {}
        },
        darwin: {
            macos: {}
        }
    }
}

export default build;