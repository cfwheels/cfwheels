[33mcommit dfe1b23ee6fc289014369c33a2ce82f044d989ff[m[33m ([m[1;36mHEAD -> [m[1;32mgithub-actions-ci[m[33m, [m[1;31morigin/github-actions-ci[m[33m)[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 21:18:45 2020 +1000

    package=controller.csrf

 src/github/tests/core-tests.sh | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit acc705b9594b1822c226a537aaf89ff7d1f8b2c2[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 21:18:29 2020 +1000

    package=controller.csrf.cookie

 src/github/tests/core-tests.sh | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit 27f82929ba11058b01f21c8d2f891dfc79c05764[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 21:14:40 2020 +1000

    oops

 wheels/tests/controller/csrf/cookie/CsrfProtectedExcept.cfc | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit d5be0554e9ac7850a4166ed9fc40403b40a96366[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 21:12:32 2020 +1000

    run single package

 src/github/tests/core-tests.sh | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit a903c8b029fb62ae0227af0bf499939fb09da6d8[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 21:08:39 2020 +1000

    test

 wheels/tests/controller/csrf/cookie/CsrfProtectedExcept.cfc | 6 [32m+++[m[31m---[m
 1 file changed, 3 insertions(+), 3 deletions(-)

[33mcommit 2720eeb2ad76f41aed6166cbb2c99887771f51e0[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 21:03:37 2020 +1000

    debug request

 wheels/tests/controller/csrf/cookie/CsrfProtectedExcept.cfc | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit e472ed75b921691a563838a26cdb22612fafa07f[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 20:56:53 2020 +1000

    debug request.cgi

 wheels/tests/controller/csrf/cookie/CsrfProtectedExcept.cfc | 5 [32m+++[m[31m--[m
 1 file changed, 3 insertions(+), 2 deletions(-)

[33mcommit 43b5e3a6b7579ee602a7eab0a7729e6c5e967f63[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 20:48:30 2020 +1000

    noisy curl

 src/github/tests/core-tests.sh | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit c28abc7031ea23d3d96c28426429949cde260dc7[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 20:43:39 2020 +1000

    noisy curl

 src/github/tests/core-tests.sh | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit 7a11278b910b8374f60c46f2f103b6ec12aeb08c[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 20:12:12 2020 +1000

    test debug scope

 wheels/tests/controller/csrf/cookie/CsrfProtectedExcept.cfc | 5 [32m+++[m[31m--[m
 1 file changed, 3 insertions(+), 2 deletions(-)

[33mcommit 5d994b594b8848ea3a40a328643a6997da7d8574[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 20:07:54 2020 +1000

    test debug strings

 wheels/tests/controller/csrf/cookie/CsrfProtectedExcept.cfc | 2 [32m++[m
 1 file changed, 2 insertions(+)

[33mcommit d528b61968bbcce4c7fa948a653a32e740595891[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 20:04:14 2020 +1000

    resolve botched merge

 wheels/public/tests/txt.cfm | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit 5fb3493c0f0ea65866ee2c720b7fe087eb5d084a[m
Merge: 86104429 00b5cdd9
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 20:03:30 2020 +1000

    Merge branch 'github-actions-ci' of https://github.com/cfwheels/cfwheels into github-actions-ci

[33mcommit 86104429112eb4bd2ca12dad6dc79f54d1c9f621[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Sat May 16 20:01:41 2020 +1000

    write serialised test debug var to txt format

 wheels/public/tests/txt.cfm |  3 [32m+++[m
 wheels/test/functions.cfm   | 34 [32m++++++++++++++++++++++++++++[m[31m------[m
 2 files changed, 31 insertions(+), 6 deletions(-)

[33mcommit 00b5cdd91ef67146bef723cd08e5638046496901[m
Author: Tom King <admin@oxalto.co.uk>
Date:   Fri May 15 11:21:49 2020 +0100

    Update txt.cfm
    
    Try resetting content

 wheels/public/tests/txt.cfm | 2 [32m+[m[31m-[m
 1 file changed, 1 insertion(+), 1 deletion(-)

[33mcommit 3ff6f38a25bde96e48495c81877752d3da337e2c[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Fri May 15 18:07:11 2020 +1000

    wtf did all the whitespace come from?

 wheels/tests/view/forms/startFormTag.cfc | 4 [32m++[m[31m--[m
 1 file changed, 2 insertions(+), 2 deletions(-)

[33mcommit e013621f37462c5eb8c1af227d8d98972457a94c[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Fri May 15 18:03:46 2020 +1000

    trying this

 wheels/public/tests/txt.cfm              | 2 [32m+[m[31m-[m
 wheels/tests/view/forms/startFormTag.cfc | 4 [32m++[m[31m--[m
 2 files changed, 3 insertions(+), 3 deletions(-)

[33mcommit a232f284e5cea5fdd43b7c939a0782383280240e[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Fri May 15 18:00:22 2020 +1000

    progress commit

 wheels/tests/_assets/plugins/overwriting/testglobalmixins/TestGlobalMixins.cfc | 0
 wheels/tests/_assets/plugins/overwriting/testglobalmixins/index.cfm            | 0
 wheels/tests/view/forms/startFormTag.cfc                                       | 1 [32m+[m
 3 files changed, 1 insertion(+)

[33mcommit cb064dd182b988fe4bbad1123399ff464d8cc495[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Fri May 15 17:55:29 2020 +1000

    ci

 config/routes.cfm          | 3 [32m+[m[31m--[m
 src/github/tests/Tasks.cfc | 2 [32m+[m[31m-[m
 2 files changed, 2 insertions(+), 3 deletions(-)

[33mcommit dd022d9744f71fee3ed60766a1ead19d6f7c817e[m
Author: Adam Chapman <adam.p.chapman@gmail.com>
Date:   Fri May 15 17:32:51 2020 +1000

    enable csrf when testing startformtag

 wheels/tests/view/forms/startFormTag.cfc | 1 [32m+[m
 1 file changed, 1 insertion(+)
