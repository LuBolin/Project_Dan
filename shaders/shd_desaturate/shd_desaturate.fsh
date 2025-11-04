varying vec2 vTc;
uniform float u_desaturation; // 0.0 = full color, 1.0 = full grayscale

void main()
{
    const vec3 ww=vec3(0.2125,0.7154,0.0721);
    vec3 irgb=texture2D(gm_BaseTexture,vTc).rgb;
    float alpha=texture2D(gm_BaseTexture,vTc).a;
    float luminance=dot(irgb,ww);

    // Mix between original color and grayscale based on desaturation amount
    vec3 grayscale = vec3(luminance,luminance,luminance);
    vec3 finalColor = mix(irgb, grayscale, u_desaturation);

    gl_FragColor=vec4(finalColor,alpha);
}
