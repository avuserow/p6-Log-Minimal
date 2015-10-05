use v6;
use Test;
use IO::Capture::Simple;
use Log::Minimal;

subtest {
    my $log = Log::Minimal.new(:default_log_level(Log::Minimal::MUTE));
    my $out = capture_stderr {
        $log.critf('critical');
        $log.warnf('warn');
        $log.infof('info');
        $log.debugf('debug');

        $log.critff('critical');
        $log.warnff('warn');
        $log.infoff('info');
        $log.debugff('debug');
    };
    is $out.defined, False;

    dies-ok {
        $log.errorf('error');
    };
    is $log.default_log_level, Log::Minimal::MUTE, 'should roll back the default_log_level';

    dies-ok {
        $log.errorff('error');
    };
    is $log.default_log_level, Log::Minimal::MUTE, 'should roll back the default_log_level';
}, 'when mute';

subtest {
    my $log = Log::Minimal.new(:default_log_level(Log::Minimal::CRITICAL));
    {
        my $out = capture_stderr {
            # $log.critf('critical');
            $log.warnf('warn');
            $log.infof('info');
            $log.debugf('debug');

            # $log.critff('critical');
            $log.warnff('warn');
            $log.infoff('info');
            $log.debugff('debug');
        };
        is $out.defined, False;
    }
    {
        my $out = capture_stderr {
            $log.critf('critical');
        };
        is $out.defined, True;
    }
    {
        my $out = capture_stderr {
            $log.critff('critical');
        };
        is $out.defined, True;
    }
}, 'when CRITICAL'
