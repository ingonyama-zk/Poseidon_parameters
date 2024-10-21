import time

M_s = 128
N = 756
t = 3
alpha = 3
n = int(N / t)  # n is log_2(prime)
R_F = 8 
R_P = 83
prime = 3618502788666131213697322783095070105623107215331596699973092056135872020481
F = GF(prime)

timer_start = 0
timer_end = 0

round_constants = ['0x1caafe19abc51e89d9e19e96658904fed74eb9e5769b70e3f9b786afb30dc0a', '0x6a49348a28b19f4c27358c56b807ada552c834c555fb0039e59af9de62c2019', '0x05228a48d4fc955881700a9c8d791626098428056657435212fe5e9f844b06d', '0x3ba61c6bd818a9f8226c750ee48812ca090a6b1e61c4c403d59018076e4bc8d', '0x6e2a2531c5b77e40fa42f804978db49ec3128dfc512eda0322e76ba7192c1e8', '0x46401bacd635a7dd2d291a4029da3c669881e860c0b6ac438f32d720cc5080e', '0x64ff3a8bd01c025e3121cea2ba866f3f5bf7ec9f670443c93dc560a8d412387', '0x55bfd0d83713139db5d42260cbe94f3e4c1cf21ecd5af4ea9ec8dc1d7ea2096', '0x0c49838bac6734c9e84cfdebbfce7761c8dff31bd112aa068f3393ac6922f03', '0x4cdf3f1c45550cf9903fe83ff089dc57fde71f21b766cbacaa3e6c578357216', '0x78ca37a2a066d3cb56e4d7ca4ea372ee2e9bbd19775a196f5f879ae13fa5ab2', '0x69739e32d9ab7cdaa0b0bd066ead0664e8d96bb7f4a42f7d587b5de6944d329', '0x673fd4917a99e14cb199ca240a313958995e9eb1c47a913be7ebfbfa5d2a7d2', '0x30baa62b25de6a89bbc71fb99c9dc870a63d023937fe61f43b27c57617fdd80', '0x64886a5ef665b774177d5b4b440ab04b7a5c1a89612951b59da0d02ead8ff0d', '0x7d1eb7b032165794cd31827245d187ffd8f9abbdc81af7ec1cb18856a2eb4de', '0x2b5a99a6b751957843aabf081ea79c3c9f5de2c31262ccf3734f80fcd2762ab', '0x1255793b24f0f860522e3f75b6ebc07cdb7e6ff8210c16e7dc5bf7c7c71639c', '0x04ecddac96630b0cb9becfeb0d7dcebb50dc750362351b28888247179a8d628', '0x79893ab13a1e627462497ac166ba177a956ca1e3c2e8bec31c3a3d8ef89d85d', '0x537edab27f234a11cfbbeb3d88034ea9be6d15906806af79e83d88c7e4ccb0b', '0x7430f75cdc58f7263447bf5c3274918b526abd57bf1bc3242480bb1412ebd09', '0x65a5821b2a99f38d220b0b82f71bb614be03f4eae7cb61bfb3567765757a64f', '0x1fef33ca367918040276992b8e2afe308a72d58966aa187db6d6d96d0143c5c', '0x417e2859a8d763d9579a2de1c5b34b1f60b8abcaac63b68c3ee29460838c0c2', '0x659fa303e5a1b91a233b43ad73b4ab43a161d045aff0f462a3619c8c504659b', '0x58a5ee378a9f49acd2a79373c382573beae03a057bc40016f9847dc274ee873', '0x480e72fdc7c17178576f277cd3e34a78f58ee64ba969ca24c6a67e52f399d0a', '0x4ff6b8383cfa589064600cccba02175d4488440e2d78154c5f2064688521e9a', '0x1d55afec1a523ad72d6d2599fa37c9860843ad37949e273e1a71049bec721eb', '0x533e1fd0e8a47ac2d434c2158f2898ef5c05d76dbec11df13d3a96b77cd1f03', '0x1f75036b4d208493a66f0693794c3b06ea52ddbc92f938b038587a07fa1cf74', '0x00f27c19da832f5f96835a024d153cf0a55ac70cb6850926e5c3565cce0f098', '0x0fa6dad9c5d5fc88dd1c65bd87abab4eabb9034966c00f10a9abfbdff7721f4', '0x1525a9da8d1ee034362e5d750cd94c72ea2231cbf2f4bdb3a2a8dbf356c517f', '0x5ea0f5cd18645f5dbf6ffd7de437a7f28d756b0da77e26908e70a2582258c53', '0x14730fe1334bdf46740b0c47aa11b9d13a2051abc71318135a9d41651bd2ba6', '0x691f607600e792ecfcfd03dd9d1049486bca2aa0a1b5304ad5dac77cadfeeb4', '0x700810ac7be2633ff68f5ba8a7832675b4528d7d372daf74654c5dc5f76a44e', '0x1b9367599c0850cbd1b2ad107a7a0cf82a5fa873121ea5c97f06197144c5da1', '0x510d4b04f2c26e18846477272d500c929275c497e690d3ffdf4edf1d843fe8b', '0x2d0b0edfd9483002bb58b93b9ec72b77a323cc270d522b67e27f70856355c11', '0x18651665380759d056a47dd537a065b9927e26e4e08e66be57eb889617076a2', '0x46fe1ddfdad9e163a88677680f9805af9db4a7304f1e3da42671813120e1f9d', '0x686745b1f6d0f97e5e78f3b5319bf20f488f4aa8cf3654ca27642e27caba0d3', '0x03670f90ff89791db3c80a7cc4e4ccf84a6f986718e4b44acf05b78c1e4e445', '0x206310fdf701f1286e498c637e6a49003054923754908b11c8b733407308b25', '0x679fe3addfab71e90be3157923e14cfcdc8cf022e0c93d0a3f823e7e4b0ddc9', '0x3efec7fc8b364d48c4b740591411d5921f32fdf3dd1b4162564d3ed7a447918', '0x2519db11ea2efcbf153a26e364bf5c91260913be3ce159d26119d09868eafe8', '0x2359738c04c88a78e93588b994b8aa800b9a458b6a71c7689fb1c8bd647e1a4', '0x03dc42a576a8d93f29ccaaf9641e2481e8a552181c09836415dcf4f41ce41e1', '0x088b2ebf0d77df7961cf95c1712a11438f258d6c3d2e014113e3d9aef7aaa6c', '0x431df2e4aa221ae184afbbec3b8a06fe9ddc3ad1a24bcd98946ed1269f7fba0', '0x2085926430c0c3a93f8bbe276008a73413d85aadeb87c35bca9c42d05a66c34', '0x6ee17a022415361e687000e8cd1bfc7ec46ace8f2de29b0893e4a0778f10d85', '0x6b690f00074215603edab594f98465e4de28fecd90f5ba2b2cafd6a7aaa9759', '0x769d18543a2369458dbe0c9b7628fd2042720f8941cfe1a44358091f47a69aa', '0x78f414a24db5f2c6d08451073649e356c4edbd8ca66a5fd212eef588d4706da', '0x75a859ba682bdb6c2967300d5151dfc32e593a6c66a5f416a44466adc18ab93', '0x6d3b2cc9b371e8feb31d30105f13bd901fb68d66b90959248378c3cf7bb7f73', '0x150bd3a290bb6a4a8818d2a69aff52d5b6ce4747381f71ab996e23138ec72e6', '0x60e7d9da09840d7c8615afc8b77d8dbc66408514effd708aac8bd728cedc3d8', '0x34ddde2b9fddab828de31956a6995885cfda7f16748dd9c73c6c3e19850dbb3', '0x7cd1821a677861bd5e1772e138616c62e149b03972a79c902af2f21e8da7c7a', '0x7c6a80fb6b4c8268f0165d904f861df60ca04f2a24357a2d4bd00915492197d', '0x52ac8cac9cb8bea5abad085f9bdccdb1f4cc903248db7f9be69a21f65d248ca', '0x0e9f66065c1fcde646aeeb6cdf2a9c923f9e6300e1a97965a0723cd2e038423', '0x572f25fccd60c87d7308a66a7fcddf580e849a6b84a9a743bd434150a9c32ec', '0x523f4914b37a6e6a93ebb32f11a2b676f64235f71d18881b7c79d8a9399cc8f', '0x48c368a4c21b1e46256bcb3c110e6ffcd418e5c33bc6bc82e18885f82eafe1f', '0x7f7b9dde8d7294927d73df6ed2e70fc4dfec7b1a402dca5abf8c0c648586724', '0x670ff50da1a477ae34d44e27a3c0e87e267322843a2f04e86c8088934fcdf57', '0x47d2e3788a6ce634c59af265553549586deb4c10038e6e6513ef64c26475f7b', '0x4096c37cc4770dc8049b4ab483818f5746ffb05cc4916a1479096113fc95720', '0x6322f2251894cf8934d5974be5a1018258acd2978fd99e0669ea61ce63944be', '0x5fcaf134497a35fd68e39a5faa41939908d1b6cfba0e1d10764cadc5892f3df', '0x27e8c046ca5751dd329fe0f499150bd40a7859f6616a31de35c0b73fc14e54e', '0x1ad15273316815c320ec79d42e535070e2b1f67e5fe6d0d54bfc1336f176189', '0x4c601a0d1098288096584faa8736bf4ff967e4d3a13389e2dbe2f7fba8b1616', '0x32c0df48c19587bf6176c7bb18fff5a4c5e6025f07f3bad827fdc8b1da682f5', '0x6bf016bcfe1b346dce014fd0683b65ff06c5deb8a311261ec5f163499a4f506', '0x68f22e49430097a2fd3446160f6900a106d6c84f7e2267123c26394187cd0e9', '0x28943ef3ae18150e46230d933e4799e98b1c9a8eed1b62c13ff182ca75a8497', '0x051939bd6cf778aae328f9812517e6f860c4b9dbe771a2755b7815a40d12f31', '0x72f0931ee56e22b129a42c51535b583ffc61859c08be04e0f144760ed0808bb', '0x36f52567bf4fa74a79ca7b625bcb7eb57103c525b7aa28dd08aa659cbdd5650', '0x635b5b1847b2a7fc7687c1b35f0d76fafbf1ecd26595e83c3025d96a535675a', '0x062357f8f54bd53cd32087d324aa13b14355702304205feb23e5a50ab611281', '0x6ef2b3a77797f7bace6a9866b02cf1d98f48f8c719061b6a07c698dc18d3ced', '0x28fcdfc38b8059df3534a0bb29699eae6a7ccd2dd6f1a28d791c95780e924f8', '0x6540dc764d1ef62efbacb347f79780a7b0526e6930426fb2f698364c4563120', '0x019c2eb9ecae2f62c644bbf6d8f0161281308851f95202d7c4b6b7741a54eee', '0x1dbbcb555d2b9ebe59b13c5d230539e05a1355cd45912c05e6751adb66155ef', '0x455a2fd9e3c2d8034d550c80e10736d99682733b35ded2775185a24012109a2', '0x534757d0cf17a80a60130345f66ceee6ccfd0eddb0b9e1740c71cf99f0d0dc0', '0x6facad21e991ed6a3871491dd8786dfb6b2b1a6ac149b6735ed249a8c9f3abf', '0x7dcc26d042cdb987f73227a56df5524c5b9aadfa0714a52de109c71d98bba03', '0x5592f68cb8c1003b35476b2b3a78c4c619d3196bd90d79412a209b1c51ae9e1', '0x204601234388ac5ce77bca83703b923512c87de9cd8a9191ef9f749540becaf', '0x5f359edc9ec808c9e1585d191796834690c8dd7c4f9b20d1fd4b34ad5ba76b8', '0x5c6dcffa770d4a505fc55da6a90cfdfd5b62062310e876cb3806a4db1768c98', '0x20e8945ed0f5c1ff4576d28bb683b859ba545a812ff20861bc73cb7c94a94db', '0x5e1bb202bd0ffbe37c7246abc67f34269e66be12c88b3b734ea52acd3652987', '0x426cd1b02689f178a17ea7858f8379ce10b2354320a7a4a2e579bf2c79832ea', '0x006c44f485087cd57554c72dcb55d962e0b3210228825e996de0fba726c2f3a', '0x6f8b831ecded2b6fd51fa94dc117dfd2e7a5990fb0ca4bb7171920ab38c17b1', '0x138cb721fa32cdfb9f345ccb635e329beba42cb992efbb55666bdede1071abb', '0x3e77e869f3b5a38d299b2bdbaa8d71de174e6673e1ab08192f762fca937429f', '0x2a33cce1fdd82d18522ca3e6220a6fc51f53f00707926c3df8b9a35882658b5', '0x23c3ffa6e12b43efbc313348a15bcd91c41a3749c9f5dcdef451792222a8de4', '0x771eab989967079bdf2592aabbc49e1d5c4f977e3f63c4694586356eea6ad80', '0x257a15ce9c798a5c6e103b1cd1a916cacc277a4ff78cf4ffb4aced66bbc990c', '0x17d09537d6cdc6fd5794d898fc002b3264d34f88aa6e71fe53f62b856d39eae', '0x7507588b0b18699e173713cd2fc164363350e2f25f849d9b0581af0c0277533', '0x0a486fd432aaecdd4f986c758fc158bb18305c8dfbec5a0e8f1b4e7857b24e5', '0x075bdeeb7c3d6c765efeceda924092a1c9f2c603324ed87f9e8aff14aa0f531', '0x2ed791798e071f92d0ff3fe575a996bf8239c1f958c1720e9f1945eb38400e1', '0x6532e6547b57ebe2562ec3e7da293a17c43ff9e4311710341cfd1db624bfd6c', '0x3a652f6e837d874e0c66f6db06dd129838ee70592c5785b1334b9cf94bfaf95', '0x52119600f76f0b03f36237344942d2fdffedd9316bff1f6b4cafd18a6aeaf75', '0x5f02a5394b703958f17749779696299c39620b369cd28300046d931d35fd65a', '0x4dbf645b9a6b275ce15210b76e856d92468f8eda6a396270161cded6f14dc38', '0x62e32eefd82cf847e2943c2b282e6f134da0d28e6f1055100a969b4a9b3b1dd', '0x58e1915270da466a47ae83d178a35777faba6a0e34445cab4354510262cefb2', '0x6bc673fa4f2b56ca89c9ea2819cebad2a975ea2bf4fce5a8dda347cbf0d98ee', '0x7b5d03123531df2e491a027310bffc9e483336f1b6c0d4a16376ffe500f0f6a', '0x70ad21a5aea904e8c361217e1dc33481e48b7efbb4fe0b8a0b198cb1ca55e77', '0x67f19880ebd66fede42869f5c99414d551e426bb6dc30d79f1c749a279be0ed', '0x1474ce7e8704e5d2d11f3c69bf27071ac58980d62c96d592fbe280e0244ae67', '0x71da502dcece22bf6d50028dabbf01d27f948aa8306f42bd596f6a900ba3da6', '0x737a374c84540a45c1718a867d847c3769013801b8c73e363a822e01204976b', '0x3370d31f1bbb09c0573dd89d7c6b6833dd7cee74a8d3e97739612e811402098', '0x5ca2d1977ba896920a6ad5b463321d393b2eb8f90c978db3de7cd9bea2e0890', '0x70712a1939291bd8dd5894ac8c0203532830bc38b45b615f1d939d8c78895eb', '0x4ca43a18cf20e453ee7055e17d5e8b664c6e885639d5b13177d7b18ba6d4658', '0x2c163a021f320b26a50d322f255c8d9f0ffee07bcf061ff472650e24e171099', '0x0335f7c1cc11cb79e48678518622edad33bf833b5d913ff0da4a6eae5e5c3d4', '0x68e4ac5d1f1e2cae625722d2da716c7d4bfe499e0b8db0bb2f936a9fe5523de', '0x19b63006cd2f6d9d2abcffe391e39b70e9d249e79983aa19acf71f982e1839f', '0x163bf004d77735a930657096480379132cd964c0341b23ce123cc5a0db4aaaa', '0x247074c0df363af887625c942e92cf31b616891d48b3c07b40b8c3ab03fcaed', '0x0b2a99e04fac24094a79a26c9e310c0f808904cafe425ef33044aa9198ecc3e', '0x14a03f3286250517accaea9286520ade312b00a5d5cb8d7dd74f2fac21335f8', '0x36598a6062bb43527b4520eb1271327844d0b006a096ec76ab9bbc0df0742d3', '0x0f3464fb16326b2e4883ffea4bc9bb7ff8ab2fed8e58ba5c2040e114b517abf', '0x72003e27b6c1a279e7e8def499677d45da525faa976ea18dc2dac87ca8a74c6', '0x644c4761caa3a0e80db9d1e7e170480b36872da54952966a2797fd86f1ec2db', '0x5567888161cf5f75e89b3475bec9771a8c28b406d8434fe651054924bb09949', '0x7621d25e1fbc04550dea508cc5591aa75bbad05a23f6055943365e239d24b6e', '0x34e36d977374f9d33bb663fe408bd20c00ff2c474a7e3ec3e854193bf9eb199', '0x68fe22be086dc3b89f4f81fa6202de49c616d5a5f47ce708229f2f0bfc53c59', '0x5f51a41a6b014b6e79dd8dc7ab1d5bedec52827cdbb405d0406944b9be16926', '0x67b49002ee03c3a511886abfe190c2c2ae231ef7347fc1db22620a0a12fea8c', '0x2e862131fb7250e95b134c6abfb75f9782c6df79483d33433f72850a54d54b3', '0x24ce2c552810dc0c120d03df0c1f01959c3e2aee3cea8638609328f9785aad9', '0x598c59d8d468938ea60ddc6662abce112d906bed8f14531026d227d0a6f2cef', '0x2db8e599e730169ad15c5b1932dceb5ea954c991b4e38cb80cf72ea1203fcca', '0x52360f3d0500fd6d32fe3a77ab24b4a100d7a2f6d2551dce4973a6c4e6e045c', '0x05653b75e6a26dec478ac8042e07d2b1bfe1580680a9c0db0c183ce85d51908', '0x52d4b2095603ad472d64c49f9762316a1da0958014bb2e2db9833400256b4cf', '0x0d01a0e211c8868d5ed114151b970a5ebb6e8a6b044b6b5d991d7b7bb76bd42', '0x1c521f3dbb1640a3874d84aaedf328222166f0122f91ce75d03bdb356e64d42', '0x3fb47f28e3c1ba946f87712ab3ad508a65609a523b2c2ae44fd21881d1088e0', '0x5719c82427f1b884379426eb7b3d3bae4a329d631f51fe0fff22b5a9b079fdf', '0x262d667565cada2f75f0b8ab6c6b0b9dd7ef3297bf4ea148162f653fec89f4d', '0x793a39fcd2899352698a615f6b19a5bb96e9b2b639f08a411af8ccf3cea6cf1', '0x4b04f83a3da1d12f352e9a9b31d11a0cfe3e7d53aa1f329bba421af38899b83', '0x02ce8441afafbf04f6df4c2acca802de8ebccf3d70cbf114c2c4285721fc423', '0x12b022b701bc37b261089a3186125e6e8c74e835a7a9703802eabaff83ca2b9', '0x760fe07f31b606862c2dc6801edb298c41efc6ab44c771014764f529de20b54', '0x1e029d287af461558807ec93c790f3def60bcb56b405f6dc0e65c0823e9256f', '0x7cfc3557b49e85a84bab7ebd7e19aaefa3ec7bfddd2f256dd93466cf3ab8480', '0x17fa60e63efd079a148ee94d0efae4d45a26a420a2cddd952f1e033e0a17d84', '0x260e02c4387acdf0d68d1d9e954241c8ff361d06b0eb8e09e869a8d654ca5e3', '0x025a82ca16389788f0f7b71fb4ba93fcbfaf852bc903f0b3c0511532ca9b2f3', '0x21b280e34e17ce2896a3ecae80732b95026c56c4917e63e47df0e13c0e43523', '0x7a958bbacf4aff116620202137a153f571ce40511bf04f73a23998b2a9990e7', '0x56f97df38365340f64b34ece3a3f22e9a27264de2a0b71c05ad4e33a4350fc5', '0x015f75302132a052f1858c144285b1459a382757f8a46843b5a66ee67c1bd09', '0x48c93394130fe0401d7215b8ff7f58c40f0138977db2e4f325b715b32c9ba91', '0x6112a452e240ca455676c77af6ac0ba8517f78e4f79f7d2bd2875f65e58204a', '0x78367e4c002580b80b6ea9c90365970f18a00be22092d3baf3a2f6938f20b46', '0x6244c350e50da8fa0a0ba59e4a819054372e6912959e4bd207dddaddb74ac02', '0x34c8e5fcd1b56ec0c5d45b06fbb3dd391b9473bdb15d60d72f9a6be2dd2ed88', '0x4dc8b21af38adb7e9069e14ec4a7954e1623931f00d4960d09f775b451874bc', '0x6abed8c220adce9edec629ff7bf51a4673a4e676ff020ae9c4727b916b6a3c6', '0x26bb5d309553728e513a162cbdba89086ea1f5958474d0c945a70b21a66b4ab', '0x40a81652649ecfa5ae4bf1fdda0d613151c30962a6c98f8721c7a98c1715878', '0x39221dff948dda15ac6bb15b0c917a3e3cf25f1200f62e4b7e24c42a7023603', '0x00277d9176dd161b39417df871430adccca6597542901dc77fc084b0f5fe831', '0x5fa489399b3cc436351a565c681be6d1a3fdd6311c6b34f57c33e7b7e690352', '0x7210b187ba8bdfde2b85de9c0ee92012dbbb428f119c16b8cfad3a0ffeb2c64', '0x291708100003d04a3ac8f82941b693a7f9dfa352c423b68ac2e103357a3112b', '0x43a7a23e9a8a92132348b015c01d9e717ae96e11822c0a0a7568bd7026b6e32', '0x75d1051bf1a9f183d4859a239c0e8cf1bdcb1ddb0a6a447cc50ee0eddbf18b8', '0x6723ee12fa070d6165765710b708e1fb95879c83c1c30a649a0f218617d1322', '0x43e6af4ee2a729fa6e7331a1509277d994c46070578e1f64f4a2ff39d4263c1', '0x244adfab3be3cb17053df91d1b0b02ef579f032d89c5a6de6fe081a9f5aec3c', '0x4b991e51943f81d131db0196c97ad44bc9232ce9ef37e4133257f47453f1db4', '0x3c87acdc7485d0e1407f88477aaf647c874ead8ec1ffe4f6aa98bdce7ba2f0b', '0x7933dbeddb52c9f3937d2c19fc5d9e353f124860653de858c2f331ac96dc440', '0x34f18f4d777788740a572758ea838c000691b652064f315e41f00ea2e9a3b34', '0x764cd4a321cd4975a5ec0545de0576e5a5fb73c786111a5d7162b607734abab', '0x586a523f696d9a35be9cb74518d516c371880716576e13eeba3a9579e8b9bfd', '0x4a6dfed4fa7439c6081cfd3c56be8922be0f1f3649a6342fe88b638866ba959', '0x6a5a7f317bf1cb4f150cdc45998780b31043811edda988121aefc0d6a9c46c1', '0x60c67838102c24fafb4f84ead3b17eda94e678370bffe7d6d7b784e445e3d35', '0x04b7290612817b9a2e15d8ee0a630814d5ad7f9d8e6aceade0005a52550c8de', '0x572e4f27e324b9407004b5d52357de297f3c56fd2b0ec175d83c03c2994d51b', '0x0c0283c9781145e662009c929c4958ef81961e40094194d54a80b9f247591cd', '0x0b3fdeecd122aec131f17d0542f5f30754d531b904ad084ea2d5f2a571c684e', '0x685f2e09b2d5200ea7f733da55889faf6baebe8652c40b71e06aadac38175ac', '0x798cb955f19fdda25d091da3248de6d4ee539cb7786ccfde3cdca1bf34f4a19', '0x17a248afb8176f30bc7568176c4ffbd8f192b20a0f58f680a47c481bba02707', '0x0bf3197dcb5d3845b3dd8f9f9c00d340662a33e87e0f7eb375ea58f695abcf6', '0x451649351c5281dec40531d4990da4d57f4ccb76ee93a333e4792bd0a73f785', '0x782e192d4dea1f28f8e709a7ffd7457ddef9d5b41cd52430c7c667cb5848cfa', '0x394e77273f73485d513d6f8477b6f5d7a2e3fb55897af9d62bdc1229ae4d003', '0x33f9387d7ffe7e6eaf8f66edc3b93acf0b4e9abad410d165edaeb3eb52be4dc', '0x429ce7cb87ed468390cf027f6df1ee16fec88a8227f8d36ba378f5f1623bcd9', '0x03f99ee9e0c8a5ab072b5a2b7c8dbcb3f1daa4d9a64694843ce4bc72e5a4561', '0x5af12b97651eb662963d3d623a9a3c37a5b85c2cb3aa4fe41845a0ef5b40a69', '0x31e835b809d4bb76e9ed6fb1d79da0829233abcca8874eacabb8f0d23665ca5', '0x3d16b639d77f7798a839e4f2724024bfe97a1fefc4f0d333554a516e9e2ce62', '0x14b89e166fbe1480c58487a97dbec2e87ba59674efe79a65bd1b4b90396cd22', '0x46b84781e51ee905b29a4fc18ac915082efa0569e186764922dc5a35b05728e', '0x4a1a9a6c2be297b76e2d80078d2c5030072077dc8038afa65e3d5ebf71724e2', '0x1fcfc5a7da9d60753884ab8b199adfd85a17083aa4b6ffd44d728ea772ca34a', '0x0e9bad5135973c9885af4b4c956a9e46dfc9038675e73e3f94468dbb4ab41df', '0x2ca9b1eb2cbd2201b8476f5ec6c2926c98d990a2a94caec23486583183b83d7', '0x79fb03558d657f7bee140239d517a6e6c3ef32179279a0bcedc6a8ddaa7990f', '0x6bad85b687ecc78419351be227fc7448b3c9092d78f148ee7e1f133d5beaced', '0x6a1e8c5aa313404827f863f719c753cd3de09db544f03a2972324720b46bb6d', '0x058932a4e567714138617f88b005185e31967784728f900d00499e8177817dc', '0x57fcf586b88805fef651abfee80ea4389e9626e3f8e2e2e73b7949924cd6024', '0x51666c415ef6d4a5d07ff6cf811c47b41735e9a27e4a95bde468982c23477b1', '0x4553538927867052d190d7fd4dfb054575b655505730e768ed0547f4b457e0f', '0x7db457d1c17fa1bac9d3cb07d61a6980a765f92525836f998c9377c51ebdb4f', '0x3e8626dd982a870978b56a96b9165aabd368246b1184d7dabeadf0854bc9734', '0x23f492d66bc8b4312133bfec5c07955b17e0064b53c7ecad37d12769a0b108c', '0x6e458d73d2fba4826dd862cf702620c21cb8f2778d90a330c8125cb3e7cb25f', '0x7aac4fb8526c49072232f4591ecea442558fbc7e8d8990c89a1cb7659a032fe', '0x555d28c9277ad932666c7469a00c78b4fa056110b0ca85d65d027429a9d1138', '0x561c01609d70b4856984b86f8f3b23f48acc12f04c9b1b0e43702df863852dd', '0x487601f451f291f333c1378fbaa4d91a2b1e3bf1e33187fee0398630ed65779', '0x728acda9a984d9f3ff8b81b7a992ea712ac6e35dcc0fc2696dd55a32e1a3e77', '0x1f49ed3a749a242793f93cec725ae6dbe5e8639910755b2988f8e53f3ca496a', '0x30b520c22ee4c35716cd5299b8aabc4bcef2fc7f370468e3c9306751a701007', '0x19eafff9cfaf87f2b5b03c82d431e9b037de67e19cb7b72ae69ba4c252c3824', '0x14f006494eb23f0bdcdce8524a740b803dc07955514a7d924dd95e7940ed4ce', '0x30485fada30bf89fdc9d5cd8ee5041939596722c321d281815aa43f6a30e62f', '0x2a75fad8ba297546096410b10c99c052b2de002b2f829e772f18827550f09ee', '0x2149eafd751a4367b43ebe281d7288cc38cfd53a986044dc0c3f6d81b79ab6f', '0x5edc382d88b01eb11d02cd3799129c68f5f4f1909bb87abb1d2b3cccc4d5c06', '0x3824599b154f01b11718c01ead95cc4088b5a182384be82ccb5784ebf01d64f', '0x2fad49d53337ff99dca3f8d2ab668eb2895859a61316ed7760f228ec1baa1c2', '0x5151afb6866ba9aa72acc41c243c20433e0f4fbccf5effe5feec676886f3a3d', '0x61d968e058d5f476202f2f6f6aa86e80dfb41e410b7d49804bf2707255513fc', '0x1ceaf5a4f0dcfbccb4219a672e1ac0861c377a33875c6f7aafe838fe335b866', '0x3bcffe969244a434cf126aed779ad6f49d5fb70933ffb1a7ba7f0650fd03767', '0x1e17917b6724914c3f0c963bd21c55d95253a02155f8def8eb2f231ed4279c2', '0x43cbeb3f3a6efa7540b9ecea1967f280314a28688414dc2456504f1a9e7887e', '0x2f5b381a8f9c4b7620d48a5760c7e3358c20d9aec81faeaf9916d5d0b25f1c4', '0x79bb24459d28f6fb38c2d727e86aaba2c7970112bd9159142017840f4831b3c', '0x73e33f1195e5b04586d4036ec1674cd94fc3b1cb94ac795ff2f72b048414c1c', '0x52863a1160abf5ff51ebfc7bd11755c5442675ea497bf5193780f0dd0ada253', '0x0af72f4ff90b1c147d7247b050900b774e5c16055b46731dfb22ed86ad2206f', '0x2af98512bc4fa49f8bf0731fb23f83a2e2d6b823e57e790e8be1c91578ea1ab', '0x3f560a48b221106c3e3e44a37d7dd5c5f1809917039bf92b5f7ec4afabdaec0', '0x7428a1fab45099b1f4f1bd313b2018ef07bd521a516e6349e83af5cd844ba28', '0x35e134db5a23c2564213ca00b71fbf059c9cd10f8ce5275dc15e1318f0e5c3d', '0x7d0557a56ef4ca1ebf374e3e552e0a5f47f0b4cd0babe352c573bac0919535f']

MDS_matrix=[['0x2c56eb48053ce90e242172d2cb40d0ff25de893528114a65359fe3dd0f253e1', '0x092a1071f52c8a810e80b8b2017047a8bf2b7fe955a394b8bba55459f4e336a', '0x25c4a18f9c45d4a48dec7536a54922844bba8431226141f35d0299f54bbd180'],['0x419fc5ba7120ce536bbc796eb8f632e6261514e63f614739f8f5a4ae7b4c81d', '0x161a651dd636206b7f04b4992ec0e273dd07429b469fc2a21b59ddaf4180963', '0x1d99cb350ca2aaa9bf2aa3c3ae44e11c232bd4e79404846578849e95a34159b'],['0x6a3a494bab4b144603b7c2d7f6a764e0ae4c0942e23aea3a440f4c620d966ec', '0x06e89fb0f895063e79b8870c469e3cfd6b7428bbbbd10ba0b53796b78348d23', '0x17fb80b7729ebd57d79396b0c0931f7526a9059e32be5dfb458c5559b30f599']]

MDS_matrix_field = matrix(F, t, t)

for i in range(0, t):
    for j in range(0, t):
        MDS_matrix_field[i, j] = F(int(MDS_matrix[i][j], 16))
round_constants_field = []
for i in range(0, (R_F + R_P) * t):
    round_constants_field.append(F(int(round_constants[i], 16)))


#MDS_matrix_field = MDS_matrix_field.transpose() # QUICK FIX TO CHANGE MATRIX MUL ORDER (BOTH M AND M^T ARE SECURE HERE!)

def print_words_to_hex(words):
    hex_length = int(ceil(float(n) / 4)) + 2 # +2 for "0x"
    print(["{0:#0{1}x}".format(int(entry), hex_length) for entry in words])

def print_concat_words_to_large(words):
    hex_length = int(ceil(float(n) / 4))
    nums = ["{0:0{1}x}".format(int(entry), hex_length) for entry in words]
    final_string = "0x" + ''.join(nums)
    print(final_string)

def calc_equivalent_constants(constants):
    constants_temp = [constants[index:index+t] for index in range(0, len(constants), t)]

    MDS_matrix_field_transpose = MDS_matrix_field.transpose()

    # Start moving round constants up
    # Calculate c_i' = M^(-1) * c_(i+1)
    # Split c_i': Add c_i'[0] AFTER the S-box, add the rest to c_i
    # I.e.: Store c_i'[0] for each of the partial rounds, and make c_i = c_i + c_i' (where now c_i'[0] = 0)
    num_rounds = R_F + R_P
    R_f = R_F / 2
    for i in range(num_rounds - 2 - R_f, R_f - 1, -1):
        inv_cip1 = list(vector(constants_temp[i+1]) * MDS_matrix_field_transpose.inverse())
        constants_temp[i] = list(vector(constants_temp[i]) + vector([0] + inv_cip1[1:]))
        constants_temp[i+1] = [inv_cip1[0]] + [0] * (t-1)


    return constants_temp

def calc_equivalent_matrices():
    # Following idea: Split M into M' * M'', where M'' is "cheap" and M' can move before the partial nonlinear layer
    # The "previous" matrix layer is then M * M'. Due to the construction of M', the M[0,0] and v values will be the same for the new M' (and I also, obviously)
    # Thus: Compute the matrices, store the w_hat and v_hat values

    MDS_matrix_field_transpose = MDS_matrix_field.transpose()

    w_hat_collection = []
    v_collection = []
    v = MDS_matrix_field_transpose[[0], list(range(1,t))]
    # print "M:", MDS_matrix_field_transpose
    # print "v:", v
    M_mul = MDS_matrix_field_transpose
    M_i = matrix(F, t, t)
    for i in range(R_P - 1, -1, -1):
        M_hat = M_mul[list(range(1,t)), list(range(1,t))]
        w = M_mul[list(range(1,t)), [0]]
        v = M_mul[[0], list(range(1,t))]
        v_collection.append(v.list())
        w_hat = M_hat.inverse() * w
        w_hat_collection.append(w_hat.list())

        # Generate new M_i, and multiplication M * M_i for "previous" round
        M_i = matrix.identity(t)
        M_i[list(range(1,t)), list(range(1,t))] = M_hat
        #M_mul = MDS_matrix_field_transpose * M_i

        test_mat = matrix(F, t, t)
        test_mat[[0], list(range(0, t))] = MDS_matrix_field_transpose[[0], list(range(0, t))]
        test_mat[[0], list(range(1, t))] = v
        test_mat[list(range(1, t)), [0]] = w_hat
        test_mat[list(range(1,t)), list(range(1,t))] = matrix.identity(t-1)

        # print M_mul == M_i * test_mat
        M_mul = MDS_matrix_field_transpose * M_i
        #return[M_i, test_mat]


        #M_mul = MDS_matrix_field_transpose * M_i
        #exit()
    #exit()
        

    # print [M_i, w_hat_collection, MDS_matrix_field_transpose[0, 0], v.list()]
    return [M_i, v_collection, w_hat_collection, MDS_matrix_field_transpose[0, 0]]

def cheap_matrix_mul(state_words, v, w_hat, M_0_0):
    state_words_new = [0] * t
    # row_1 = [M_0_0] + v
    # print "r1:", row_1
    # state_words_new[0] = sum([row_1[i] * state_words[i] for i in range(0, t)])
    # mul_column = [(state_words[0] * w_hat[i]) for i in range(0, t-1)]
    # add_column = [(mul_column[i] + state_words[i+1]) for i in range(0, t-1)]
    # state_words_new = [state_words_new[0]] + add_column
    # print "1:", state_words_new
    column_1 = [M_0_0] + w_hat
    state_words_new[0] = sum([column_1[i] * state_words[i] for i in range(0, t)])
    mul_row = [(state_words[0] * v[i]) for i in range(0, t-1)]
    add_row = [(mul_row[i] + state_words[i+1]) for i in range(0, t-1)]
    state_words_new = [state_words_new[0]] + add_row

    # test_mat = matrix(F, t, t)
    # # print "r2:", matrix([M_0_0] + v).list()
    # # print row_1 == matrix([M_0_0] + v).list()
    # test_mat[[0], range(0, t)] = matrix([M_0_0] + v)
    # test_mat[range(1, t), [0]] = matrix(w_hat).transpose()
    # test_mat[range(1,t), range(1,t)] = matrix.identity(t-1)
    # state_words_new = list(vector(state_words) * test_mat)
    # print "2:", state_words_new

    return state_words_new

def perm(input_words):
    round_constants_field_new = calc_equivalent_constants(round_constants_field)
    [M_i, v_collection, w_hat_collection, M_0_0] = calc_equivalent_matrices()
    #[M_i, test_mat] = calc_equivalent_matrices()
    
    global timer_start, timer_end

    timer_start = time.time()

    R_f = int(R_F / 2)

    round_constants_round_counter = 0

    state_words = list(input_words)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    # Initial constants addition
    for i in range(0, t):
        state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
    # First full matrix multiplication
    state_words = list(vector(state_words) * M_i)
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        #state_words = list(vector(state_words) * M_i)
        state_words[0] = (state_words[0])^3
        # Moved constants addition
        if r < (R_P - 1):
            round_constants_round_counter += 1
            state_words[0] = state_words[0] + round_constants_field_new[round_constants_round_counter][0]
        # Optimized multiplication with cheap matrices
        state_words = cheap_matrix_mul(state_words, v_collection[R_P - r - 1], w_hat_collection[R_P - r - 1], M_0_0)
    round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    timer_end = time.time()
    
    return state_words

def perm_original(input_words):
    round_constants_field_new = [round_constants_field[index:index+t] for index in range(0, len(round_constants_field), t)]

    global timer_start, timer_end
    
    timer_start = time.time()

    R_f = int(R_F / 2)

    round_constants_round_counter = 0

    state_words = list(input_words)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        state_words[0] = (state_words[0])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1
    
    timer_end = time.time()

    return state_words

input_words = []
for i in range(0, t):
    input_words.append(F(i))

output_words = None
num_iterations = 10
total_time_passed = 0
for i in range(0, num_iterations):
    output_words = perm_original(input_words)
    time_passed = timer_end - timer_start
    total_time_passed += time_passed
average_time = total_time_passed / float(num_iterations)
print("Average time for unoptimized:", average_time)

print("Input:")
print_words_to_hex(input_words)
print("Output:")
print_words_to_hex(output_words)

# print("Input (concat):")
# print_concat_words_to_large(input_words)
# print("Output (concat):")
# print_concat_words_to_large(output_words)

total_time_passed = 0
for i in range(0, num_iterations):
    output_words = perm(input_words)
    time_passed = timer_end - timer_start
    total_time_passed += time_passed
average_time = total_time_passed / float(num_iterations)
print("Average time for optimized:", average_time)

print("Input:")
print_words_to_hex(input_words)
print("Output:")
print_words_to_hex(output_words)

# print("Input (concat):")
# print_concat_words_to_large(input_words)
# print("Output (concat):")
# print_concat_words_to_large(output_words)



#----snippet to print optimized constants used in this code

round_constants_field_new = calc_equivalent_constants(round_constants_field)
[M_i, v_collection, w_hat_collection, M_0_0] = calc_equivalent_matrices()

# Flags
write_file = True

FILE = None
if write_file == True:
    FILE = open("optimized_poseidon_params_n%d_t%d_alpha%d_M%d.txt"%(n, t, alpha, M_s),'w')
    FILE.write("Params: n=%d, t=%d, alpha=%d, M=%d, R_F=%d, R_P=%d\n"%(n, t, alpha, M_s, R_F,R_P))
    FILE.write("Modulus = %d\n"%(prime))
#    FILE.write("Number of S-boxes: %d\n"%(ROUND_NUMBERS[2]))
    # FILE.write("Number of S-boxes per state element: %d\n"%(ceil(ROUND_NUMBERS[2] / float(NUM_CELLS))))

def print_round_constants_optimized(round_constants_optimized,n):
    if write_file == True:
            FILE.write("Optimized Round constants for GF(p):\n")

#   hex_length = int(ceil(float(n) / 4)) + 2 # +2 for "0x"
#    print(["{0:#0{1}x}".format(hex(entry), hex_length) for entry in round_constants_optimized])

    if write_file == True:
        FILE.write(str([entry for entry in round_constants_optimized]) + "\n\n")

def print_pre_sparse(M, t):       
    matrix_string = "["
    for i in range(0, t):
        matrix_string += str([entry for entry in M[i]])
        if i < (t-1):
            matrix_string += ","
    matrix_string += "]"
   # print("Pre_sparse MDS matrix:\n", matrix_string)
    if write_file == True:
        FILE.write("Pre_sparse MDS matrix::\n" + str(matrix_string)+ "\n\n")

def print_v(v_collection):
    if write_file == True:
        FILE.write("v collection: vector dimension: 1 x "+str(t-1)+"\n ")
        FILE.write(str([entry for entry in v_collection]) + "\n \n ")

def print_w_hat(w_hat_collection):
    if write_file == True:
        FILE.write("w_hat_collection:  vector dimension:" +str(t-1)+ " x 1" + "\n")
        FILE.write(str([entry for entry in w_hat_collection]) + "\n\n")

print_round_constants_optimized(round_constants_field_new, n)
print_pre_sparse(M_i, t)

if write_file == True:
    FILE.write("M_0_0:\n " + str(M_0_0)+ "\n\n")

print_v(v_collection)
print_w_hat(w_hat_collection)


if write_file == True:
    FILE.close()