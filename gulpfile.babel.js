import autoprefixer from 'autoprefixer';
import cssMqpacker from 'css-mqpacker';
import csswring from 'csswring';
import gulp from 'gulp';
import gulpLoadPlugins from 'gulp-load-plugins';
import minimist from 'minimist';
import path from 'path';
import uglify from 'gulp-uglify';

const $ = gulpLoadPlugins();
const argv = minimist(process.argv.slice(2));

gulp.task('css', () => {
  gulp.src(argv.in)
    .pipe($.postcss([
      autoprefixer({
        browers: [
          'IE >= 9',
          'iOS >= 8',
          'Android >= 4.0',
          'Firefox ESR',
          'last 2 versions',
          '> 5%',
        ],
      }),
      cssMqpacker(),
      csswring(),
    ]))
    .pipe($.rename(path.basename(argv.out)))
    .pipe(gulp.dest(path.dirname(argv.out)));
});

gulp.task('less', () => {
  gulp.src(argv.in)
    .pipe($.less())
    .pipe($.postcss([
      autoprefixer({
        browers: [
          'IE >= 9',
          'iOS >= 8',
          'Android >= 4.0',
          'Firefox ESR',
          'last 2 versions',
          '> 5%',
        ],
      }),
      cssMqpacker(),
      csswring(),
    ]))
    .pipe($.rename(path.basename(argv.out)))
    .pipe(gulp.dest(path.dirname(argv.out)));
});

gulp.task('js', () => {
  gulp.src(argv.in)
    .pipe($.concat('tmp.js', {newLine:';'}))
    .pipe($.babel({
      presets:[
        ['env', {
          'targets': {
            "browsers": [
              'ie >= 9',
              'ios >= 8',
              'android >= 4.0',
              'firefox esr',
              'last 2 versions',
            ],
          },
        }],
      ],
    }))
    .pipe(
      uglify({
        output: {
          ascii_only: true,
          comments: (node, comment) => (comment.type === 'comment2' && (comment.value + "").substr(0, 1) === '!'),
        },
        compress: {
          unsafe: true,
        },
      })
    )
    .pipe($.rename(path.basename(argv.out)))
    .pipe(gulp.dest(path.dirname(argv.out)));
});
