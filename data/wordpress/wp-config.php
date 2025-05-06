<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wpuser' );

/** Database password */
define( 'DB_PASSWORD', 'wppass' );

/** Database hostname */
define( 'DB_HOST', 'mariadb:3306' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          'c5Fk47d$/IfS2%@3,]&zw__~,ve)LVPk2<><C&z.t9s;:HU7p 0FM{rt$gB| 7b4' );
define( 'SECURE_AUTH_KEY',   '%OMI |[*7+,Q9#1=K,b,G0]-^-OGE,rt=OJ_Sw/X[k%Q:E/A,?];LQ}tq?HOha,!' );
define( 'LOGGED_IN_KEY',     'CUr)]Qo:KG;c_9G%-[Sf-Mg.(?Lff:6RdeSFO^FD LP~Z!+ WH(uhmEtBm1:*4~k' );
define( 'NONCE_KEY',         '#zzJy?zIRad?0QA69pXPBGEqUH#m{;o&vO+s%g1n2Eo####A2J+J/5T<|:9JU%jC' );
define( 'AUTH_SALT',         'T-5CU&bTSSgSuo$okSM2aLlW%4DTt`Wc76odQ<.C5/8SN%t8G0!MR!heHdfH]F$V' );
define( 'SECURE_AUTH_SALT',  '<Aka14q(]n:t?v_}4I;_$[c _LyKr[C!9EXNOu Si5V4Gs)=QVLb@TvfyS=UWB9Y' );
define( 'LOGGED_IN_SALT',    '%*>)LCz_f?3:fXLkhhec@~uB=.c9[$vV3:,~(ICgTungvXZ7xRs`*o=4[}xqPyVi' );
define( 'NONCE_SALT',        'K|=3w0V}i5*,n+H)M1Cw64}6[c|aLo${AOSY&h^IYoeip>1/Dp>Wz-/@[Gq^NkFf' );
define( 'WP_CACHE_KEY_SALT', 'Pga3DJvm#%<^MWD6s|Rkot+&P{-aGMg,NBscrfH>O=KI*eJ-&ZZFOj~k^l/#]yd>' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
